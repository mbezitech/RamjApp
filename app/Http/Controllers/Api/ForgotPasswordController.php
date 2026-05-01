<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AppSetting;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\Validator;
use Exception;

class ForgotPasswordController extends Controller
{
    public function sendResetLink(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Email not found',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = User::where('email', $request->email)->first();
        $token = Password::createToken($user);

        $smtpHost = AppSetting::get('smtp_host', '');

        if ($smtpHost) {
            try {
                $this->configureAndSendEmail($user, $token);

                return response()->json([
                    'message' => 'Password reset instructions sent to your email',
                ]);
            } catch (Exception $e) {
                \Log::error('Password reset email failed: ' . $e->getMessage());
                \Log::error('Stack: ' . $e->getTraceAsString());

                return response()->json([
                    'message' => 'Failed to send email: ' . $e->getMessage(),
                ], 500);
            }
        }

        return response()->json([
            'message' => 'SMTP not configured. Use this token: ' . $token,
            'token' => $token,
            'email' => $request->email,
        ]);
    }

    private function configureAndSendEmail($user, $token)
    {
        $config = [
            'driver' => 'smtp',
            'host' => AppSetting::get('smtp_host', ''),
            'port' => AppSetting::get('smtp_port', '587'),
            'username' => AppSetting::get('smtp_username', ''),
            'password' => AppSetting::get('smtp_password', ''),
            'encryption' => AppSetting::get('smtp_encryption', 'tls') === 'none' ? null : AppSetting::get('smtp_encryption', 'tls'),
            'from' => [
                'address' => AppSetting::get('mail_from_address', 'noreply@medfoot.com'),
                'name' => AppSetting::get('mail_from_name', 'MedFootApp'),
            ],
            'timeout' => 30,
            'verify_peer' => false,
        ];

        $transport = new \Symfony\Component\Mailer\Transport\Smtp\EsmtpTransport(
            $config['host'],
            (int) $config['port'],
            $config['encryption'] !== null
        );

        if ($config['username']) {
            $transport->setUsername($config['username']);
        }
        if ($config['password']) {
            $transport->setPassword($config['password']);
        }

        $mailer = new \Symfony\Component\Mailer\Mailer($transport);

        $fromName = $config['from']['name'];
        $fromAddress = $config['from']['address'];

        $email = (new \Symfony\Component\Mime\Email())
            ->from(new \Symfony\Component\Mime\Address($fromAddress, $fromName))
            ->to($user->email)
            ->subject('Reset Your Password - ' . $fromName)
            ->html(view('emails.reset-password', [
                'token' => $token,
                'email' => $user->email,
                'appName' => $fromName,
            ])->render());

        $mailer->send($email);
    }

    public function reset(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'token' => 'required',
            'email' => 'required|email|exists:users,email',
            'password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
            ], 422);
        }

        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($user, $password) {
                $user->forceFill([
                    'password' => bcrypt($password),
                ])->save();
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return response()->json([
                'message' => 'Password reset successfully',
            ]);
        }

        return response()->json([
            'message' => 'Invalid or expired reset token',
        ], 400);
    }
}

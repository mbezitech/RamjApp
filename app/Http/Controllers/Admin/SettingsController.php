<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AppSetting;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function index()
    {
        $settings = [
            'smtp_host' => AppSetting::get('smtp_host', ''),
            'smtp_port' => AppSetting::get('smtp_port', '587'),
            'smtp_username' => AppSetting::get('smtp_username', ''),
            'smtp_password' => AppSetting::get('smtp_password', ''),
            'smtp_encryption' => AppSetting::get('smtp_encryption', 'tls'),
            'mail_from_address' => AppSetting::get('mail_from_address', ''),
            'mail_from_name' => AppSetting::get('mail_from_name', 'MedFootApp'),
            'notify_registration_enabled' => AppSetting::get('notify_registration_enabled', 'true'),
            'notify_approval_enabled' => AppSetting::get('notify_approval_enabled', 'true'),
        ];

        return view('admin.settings.index', compact('settings'));
    }

    public function update(Request $request)
    {
        $validated = $request->validate([
            'smtp_host' => 'nullable|string',
            'smtp_port' => 'nullable|integer',
            'smtp_username' => 'nullable|string',
            'smtp_password' => 'nullable|string',
            'smtp_encryption' => 'nullable|in:tls,ssl,none',
            'mail_from_address' => 'nullable|email',
            'mail_from_name' => 'nullable|string',
            'notify_registration_enabled' => 'nullable|in:0,1',
            'notify_approval_enabled' => 'nullable|in:0,1',
        ]);

        foreach ($validated as $key => $value) {
            AppSetting::set($key, $value);
        }

        return redirect()->route('admin.settings')
            ->with('success', 'Settings updated successfully.');
    }

    public function testMail(Request $request)
    {
        $validated = $request->validate([
            'test_email' => 'required|email',
        ]);

        try {
            $this->sendDirectEmail(
                $validated['test_email'],
                'Test Email - ' . AppSetting::get('mail_from_name', 'MedFootApp'),
                'This is a test email from your MedFootApp admin panel. SMTP is configured correctly!'
            );

            return redirect()->route('admin.settings')
                ->with('success', 'Test email sent successfully! Check your inbox.');
        } catch (\Exception $e) {
            \Log::error('Test email failed: ' . $e->getMessage());
            return redirect()->route('admin.settings')
                ->with('error', 'Failed: ' . $e->getMessage());
        }
    }

    private function sendDirectEmail($to, $subject, $body)
    {
        $transport = new \Symfony\Component\Mailer\Transport\Smtp\EsmtpTransport(
            AppSetting::get('smtp_host', ''),
            (int) AppSetting::get('smtp_port', '587'),
            AppSetting::get('smtp_encryption', 'tls') !== 'none'
        );

        $username = AppSetting::get('smtp_username', '');
        $password = AppSetting::get('smtp_password', '');
        if ($username) $transport->setUsername($username);
        if ($password) $transport->setPassword($password);

        $mailer = new \Symfony\Component\Mailer\Mailer($transport);

        $email = (new \Symfony\Component\Mime\Email())
            ->from(new \Symfony\Component\Mime\Address(
                AppSetting::get('mail_from_address', 'noreply@medfoot.com'),
                AppSetting::get('mail_from_name', 'MedFootApp')
            ))
            ->to($to)
            ->subject($subject)
            ->text($body);

        $mailer->send($email);
    }
}

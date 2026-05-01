<?php

namespace App\Notifications;

use App\Models\AppSetting;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Facades\Lang;

class ResetPasswordNotification extends Notification
{
    use Queueable;

    protected $token;

    public function __construct($token)
    {
        $this->token = $token;
    }

    public function via($notifiable)
    {
        return ['mail'];
    }

    public function toMail($notifiable)
    {
        $fromName = AppSetting::get('mail_from_name', 'MedFootApp');

        return (new ResetPasswordMail(
            $fromName,
            $this->token,
            $notifiable->email
        ))->to($notifiable->email);
    }
}

class ResetPasswordMail extends Mailable
{
    protected $fromName;
    protected $token;
    protected $email;

    public function __construct($fromName, $token, $email)
    {
        $this->fromName = $fromName;
        $this->token = $token;
        $this->email = $email;
    }

    public function build()
    {
        return $this->subject('Reset Your Password - ' . $this->fromName)
            ->view('emails.reset-password')
            ->with([
                'token' => $this->token,
                'email' => $this->email,
                'appName' => $this->fromName,
            ]);
    }
}

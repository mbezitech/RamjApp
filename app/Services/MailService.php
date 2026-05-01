<?php

namespace App\Services;

use App\Models\AppSetting;
use Exception;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport\Smtp\EsmtpTransport;
use Symfony\Component\Mime\Address;
use Symfony\Component\Mime\Email;

class MailService
{
    public static function send(string $to, string $toName, string $subject, string $view, array $data = []): bool
    {
        $smtpHost = AppSetting::get('smtp_host', '');
        if (!$smtpHost) {
            return false;
        }

        $config = [
            'host' => AppSetting::get('smtp_host', ''),
            'port' => AppSetting::get('smtp_port', '587'),
            'username' => AppSetting::get('smtp_username', ''),
            'password' => AppSetting::get('smtp_password', ''),
            'encryption' => AppSetting::get('smtp_encryption', 'tls') === 'none' ? null : AppSetting::get('smtp_encryption', 'tls'),
            'from_address' => AppSetting::get('mail_from_address', 'noreply@medfoot.com'),
            'from_name' => AppSetting::get('mail_from_name', 'MedFootApp'),
        ];

        $transport = new EsmtpTransport(
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

        $mailer = new Mailer($transport);

        $email = (new Email())
            ->from(new Address($config['from_address'], $config['from_name']))
            ->to(new Address($to, $toName))
            ->subject($subject)
            ->html(view($view, array_merge($data, ['appName' => $config['from_name']]))->render());

        $mailer->send($email);

        return true;
    }

    public static function sendTo(string $to, string $subject, string $view, array $data = []): bool
    {
        return static::send($to, '', $subject, $view, $data);
    }
}

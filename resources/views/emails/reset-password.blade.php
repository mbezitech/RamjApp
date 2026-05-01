<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f5f5f5;">
    <table width="100%" cellpadding="0" cellspacing="0" style="background: #f5f5f5; padding: 40px 0;">
        <tr>
            <td align="center">
                <table width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    <tr>
                        <td style="background: #c74454; padding: 32px; text-align: center;">
                            <h1 style="color: white; margin: 0; font-size: 24px;">Reset Your Password</h1>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 32px;">
                            <p style="color: #333; font-size: 16px; line-height: 1.6; margin: 0 0 24px 0;">
                                Hello,
                            </p>
                            <p style="color: #333; font-size: 16px; line-height: 1.6; margin: 0 0 24px 0;">
                                We received a request to reset your password for your {{ $appName }} account. Use the token below to set a new password:
                            </p>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background: #f8fafc; border: 2px dashed #c74454; border-radius: 8px; padding: 20px; text-align: center;">
                                        <p style="color: #999; font-size: 12px; margin: 0 0 8px 0; text-transform: uppercase; letter-spacing: 1px;">Your Reset Token</p>
                                        <p style="color: #c74454; font-size: 28px; font-weight: bold; margin: 0; font-family: monospace; letter-spacing: 2px;">{{ $token }}</p>
                                    </td>
                                </tr>
                            </table>
                            <p style="color: #999; font-size: 14px; line-height: 1.6; margin: 24px 0 0 0;">
                                If you did not request a password reset, please ignore this email. Your password will not be changed.
                            </p>
                            <p style="color: #999; font-size: 14px; line-height: 1.6; margin: 16px 0 0 0;">
                                This token will expire in 1 hour.
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="background: #f8fafc; padding: 20px; text-align: center; border-top: 1px solid #eee;">
                            <p style="color: #999; font-size: 12px; margin: 0;">
                                &copy; {{ date('Y') }} {{ $appName }}. All rights reserved.
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>

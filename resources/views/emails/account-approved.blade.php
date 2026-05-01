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
                        <td style="background: #28a745; padding: 32px; text-align: center;">
                            <h1 style="color: white; margin: 0; font-size: 24px;">Account Approved!</h1>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 32px;">
                            <p style="color: #333; font-size: 16px; line-height: 1.6; margin: 0 0 24px 0;">
                                Hello {{ $userName }},
                            </p>
                            <p style="color: #333; font-size: 16px; line-height: 1.6; margin: 0 0 24px 0;">
                                Great news! Your {{ $appName }} account has been <strong style="color: #28a745;">approved</strong>. You now have full access to all features of the platform.
                            </p>
                            @if(isset($businessName))
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background: #d4edda; border: 1px solid #28a745; border-radius: 8px; padding: 16px;">
                                        <p style="color: #155724; font-size: 14px; margin: 0 0 8px 0; font-weight: bold;">
                                            Business Account Details
                                        </p>
                                        <p style="color: #155724; font-size: 14px; margin: 0 0 4px 0;">
                                            <strong>Business:</strong> {{ $businessName }}
                                        </p>
                                        @if(isset($businessType))
                                        <p style="color: #155724; font-size: 14px; margin: 0;">
                                            <strong>Type:</strong> {{ $businessType }}
                                        </p>
                                        @endif
                                    </td>
                                </tr>
                            </table>
                            @endif
                            <p style="color: #333; font-size: 16px; line-height: 1.6; margin: 24px 0 0 0;">
                                You can now log in to your account and start using the platform. If you have any questions, feel free to reach out to our support team.
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

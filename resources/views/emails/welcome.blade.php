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
                            <h1 style="color: white; margin: 0; font-size: 24px;">Welcome to {{ $appName }}!</h1>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 32px;">
                            <p style="color: #333; font-size: 16px; line-height: 1.6; margin: 0 0 24px 0;">
                                Hello {{ $userName }},
                            </p>
                            <p style="color: #333; font-size: 16px; line-height: 1.6; margin: 0 0 24px 0;">
                                Thank you for registering with {{ $appName }}. Your account has been created successfully.
                            </p>
                            @if($isBusiness)
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background: #fff3cd; border: 1px solid #ffc107; border-radius: 8px; padding: 16px;">
                                        <p style="color: #856404; font-size: 14px; margin: 0 0 8px 0; font-weight: bold;">
                                            Business Account Pending Approval
                                        </p>
                                        <p style="color: #856404; font-size: 14px; margin: 0;">
                                            Your business account is currently under review. We will notify you once your account has been approved and you can start using all features.
                                        </p>
                                    </td>
                                </tr>
                            </table>
                            @else
                            <p style="color: #333; font-size: 16px; line-height: 1.6; margin: 0 0 24px 0;">
                                You can now log in and start exploring our platform.
                            </p>
                            @endif
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background: #f8fafc; border-radius: 8px; padding: 20px;">
                                        <p style="color: #999; font-size: 12px; margin: 0 0 8px 0; text-transform: uppercase; letter-spacing: 1px;">Your Account Email</p>
                                        <p style="color: #333; font-size: 16px; font-weight: bold; margin: 0;">{{ $userEmail }}</p>
                                    </td>
                                </tr>
                            </table>
                            <p style="color: #999; font-size: 14px; line-height: 1.6; margin: 24px 0 0 0;">
                                If you did not create this account, please contact our support team immediately.
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

@extends('admin.layout')

@section('title', 'Settings')

@section('content')
    <div class="flex flex-col md:flex-row md:items-end justify-between gap-md mb-lg">
        <div>
            <h1 class="text-h1 text-on-surface tracking-tight font-bold">Settings</h1>
            <p class="text-body-md text-on-surface-variant">Configure SMTP settings and email notifications.</p>
        </div>
    </div>

    <div class="max-w-3xl space-y-lg">
        <form method="POST" action="{{ route('admin.settings.update') }}" class="bg-white border border-outline-variant rounded-xl p-md">
            @csrf

            <div class="space-y-lg">
                <div>
                    <h2 class="text-[15px] font-semibold text-on-surface mb-md flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">mail</span>
                        SMTP Configuration
                    </h2>
                    <div class="grid grid-cols-2 gap-md">
                        <div class="col-span-2">
                            <label class="block text-[11px] font-bold text-on-surface-variant mb-1">SMTP Host</label>
                            <input type="text" name="smtp_host" value="{{ old('smtp_host', $settings['smtp_host']) }}"
                                class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none"
                                placeholder="smtp.gmail.com">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-on-surface-variant mb-1">SMTP Port</label>
                            <input type="number" name="smtp_port" value="{{ old('smtp_port', $settings['smtp_port']) }}"
                                class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none"
                                placeholder="587">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-on-surface-variant mb-1">Encryption</label>
                            <select name="smtp_encryption" class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary outline-none">
                                <option value="tls" {{ $settings['smtp_encryption'] == 'tls' ? 'selected' : '' }}>TLS</option>
                                <option value="ssl" {{ $settings['smtp_encryption'] == 'ssl' ? 'selected' : '' }}>SSL</option>
                                <option value="none" {{ $settings['smtp_encryption'] == 'none' ? 'selected' : '' }}>None</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-on-surface-variant mb-1">SMTP Username</label>
                            <input type="text" name="smtp_username" value="{{ old('smtp_username', $settings['smtp_username']) }}"
                                class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none"
                                placeholder="your@email.com">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-on-surface-variant mb-1">SMTP Password</label>
                            <input type="password" name="smtp_password" value="{{ old('smtp_password', $settings['smtp_password']) }}"
                                class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none"
                                placeholder="••••••••">
                            @if($settings['smtp_password'])
                                <p class="text-[10px] text-on-surface-variant mt-1">Configured (leave blank to keep current)</p>
                            @endif
                        </div>
                    </div>
                </div>

                <div class="border-t border-outline-variant pt-lg">
                    <h2 class="text-[15px] font-semibold text-on-surface mb-md flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">badge</span>
                        Sender Information
                    </h2>
                    <div class="grid grid-cols-2 gap-md">
                        <div>
                            <label class="block text-[11px] font-bold text-on-surface-variant mb-1">From Email</label>
                            <input type="email" name="mail_from_address" value="{{ old('mail_from_address', $settings['mail_from_address']) }}"
                                class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none"
                                placeholder="noreply@medfoot.com">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-on-surface-variant mb-1">From Name</label>
                            <input type="text" name="mail_from_name" value="{{ old('mail_from_name', $settings['mail_from_name']) }}"
                                class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none"
                                placeholder="MedFootApp">
                        </div>
                    </div>
                </div>

                <div class="border-t border-outline-variant pt-lg">
                    <h2 class="text-[15px] font-semibold text-on-surface mb-md flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">notifications</span>
                        Email Notifications
                    </h2>
                    <div class="space-y-sm">
                        <div class="flex items-center justify-between p-sm bg-surface-container-low rounded-lg">
                            <div>
                                <p class="text-sm font-medium text-on-surface">New Registration</p>
                                <p class="text-[11px] text-on-surface-variant">Send welcome email to users after registration</p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="hidden" name="notify_registration_enabled" value="0">
                                <input type="checkbox" name="notify_registration_enabled" value="1"
                                    {{ old('notify_registration_enabled', $settings['notify_registration_enabled']) == '1' ? 'checked' : '' }}
                                    class="sr-only peer">
                                <div class="w-11 h-6 bg-gray-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary/20 rounded-full peer peer-checked:after:translate-x-full after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
                            </label>
                        </div>
                        <div class="flex items-center justify-between p-sm bg-surface-container-low rounded-lg">
                            <div>
                                <p class="text-sm font-medium text-on-surface">Account Approval</p>
                                <p class="text-[11px] text-on-surface-variant">Send notification when business account is approved</p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="hidden" name="notify_approval_enabled" value="0">
                                <input type="checkbox" name="notify_approval_enabled" value="1"
                                    {{ old('notify_approval_enabled', $settings['notify_approval_enabled']) == '1' ? 'checked' : '' }}
                                    class="sr-only peer">
                                <div class="w-11 h-6 bg-gray-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary/20 rounded-full peer peer-checked:after:translate-x-full after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
                            </label>
                        </div>
                    </div>
                </div>

                <div class="flex justify-end gap-sm pt-md border-t border-outline-variant">
                    <a href="{{ route('admin.dashboard') }}" class="px-md py-sm border border-outline-variant rounded-lg text-sm text-on-surface-variant hover:bg-surface-container-low transition-colors">
                        Cancel
                    </a>
                    <button type="submit" class="bg-primary-container text-on-primary px-md py-sm rounded-lg text-[11px] font-bold hover:bg-primary transition-colors">
                        Save Settings
                    </button>
                </div>
            </div>
        </form>

        <form method="POST" action="{{ route('admin.settings.test-mail') }}" class="bg-white border border-outline-variant rounded-xl p-md">
            @csrf
            <h2 class="text-[15px] font-semibold text-on-surface mb-md flex items-center gap-sm">
                <span class="material-symbols-outlined text-primary">check_circle</span>
                Test Email
            </h2>
            <p class="text-sm text-on-surface-variant mb-md">Send a test email to verify your SMTP settings are working.</p>
            <div class="flex gap-md items-end">
                <div class="flex-1">
                    <label class="block text-[11px] font-bold text-on-surface-variant mb-1">Send test email to:</label>
                    <input type="email" name="test_email" required
                        class="w-full border border-outline-variant rounded-lg px-sm py-sm text-sm focus:ring-2 focus:ring-primary outline-none"
                        placeholder="test@email.com">
                </div>
                <button type="submit" class="bg-secondary text-white px-md py-sm rounded-lg text-[11px] font-bold hover:brightness-90 transition-colors whitespace-nowrap">
                    Send Test
                </button>
            </div>
        </form>

        <div class="bg-blue-50 border border-blue-200 rounded-xl p-md">
            <div class="flex gap-sm">
                <span class="material-symbols-outlined text-blue-400">info</span>
                <div>
                    <h3 class="text-sm font-medium text-blue-800">How to configure</h3>
                    <ul class="mt-2 text-sm text-blue-700 space-y-1">
                        <li>• <strong>Gmail:</strong> Use an App Password (not your regular password). Enable 2FA first.</li>
                        <li>• <strong>Host:</strong> smtp.gmail.com, <strong>Port:</strong> 587, <strong>Encryption:</strong> TLS</li>
                        <li>• Enable/disable individual email notifications using the toggles above</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
@endsection

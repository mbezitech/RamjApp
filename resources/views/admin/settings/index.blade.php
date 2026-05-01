@extends('admin.layout')

@section('title', 'Settings')

@section('content')
<div class="mb-6">
    <h1 class="text-2xl font-bold text-gray-800">Settings</h1>
    <p class="text-gray-600 mt-1">Configure SMTP settings and email notifications</p>
</div>

<div class="max-w-3xl space-y-6">
    <form method="POST" action="{{ route('admin.settings.update') }}" class="bg-white rounded-lg shadow p-6">
        @csrf

        <div class="space-y-6">
            <div>
                <h2 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                    </svg>
                    SMTP Configuration
                </h2>

                <div class="grid grid-cols-2 gap-4">
                    <div class="col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">SMTP Host</label>
                        <input type="text" name="smtp_host" value="{{ old('smtp_host', $settings['smtp_host']) }}"
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary"
                            placeholder="smtp.gmail.com">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">SMTP Port</label>
                        <input type="number" name="smtp_port" value="{{ old('smtp_port', $settings['smtp_port']) }}"
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary"
                            placeholder="587">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Encryption</label>
                        <select name="smtp_encryption" class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary">
                            <option value="tls" {{ $settings['smtp_encryption'] == 'tls' ? 'selected' : '' }}>TLS</option>
                            <option value="ssl" {{ $settings['smtp_encryption'] == 'ssl' ? 'selected' : '' }}>SSL</option>
                            <option value="none" {{ $settings['smtp_encryption'] == 'none' ? 'selected' : '' }}>None</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">SMTP Username</label>
                        <input type="text" name="smtp_username" value="{{ old('smtp_username', $settings['smtp_username']) }}"
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary"
                            placeholder="your@email.com">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">SMTP Password</label>
                        <input type="password" name="smtp_password" value="{{ old('smtp_password', $settings['smtp_password']) }}"
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary"
                            placeholder="••••••••">
                        @if($settings['smtp_password'])
                        <p class="text-xs text-gray-500 mt-1">Configured (leave blank to keep current)</p>
                        @endif
                    </div>
                </div>
            </div>

            <div class="border-t pt-6">
                <h2 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                    Sender Information
                </h2>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">From Email</label>
                        <input type="email" name="mail_from_address" value="{{ old('mail_from_address', $settings['mail_from_address']) }}"
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary"
                            placeholder="noreply@medfoot.com">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">From Name</label>
                        <input type="text" name="mail_from_name" value="{{ old('mail_from_name', $settings['mail_from_name']) }}"
                            class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary"
                            placeholder="MedFootApp">
                    </div>
                </div>
            </div>

            <div class="border-t pt-6">
                <h2 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                    </svg>
                    Email Notifications
                </h2>

                <div class="space-y-4">
                    <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                        <div>
                            <p class="font-medium text-gray-800">New Registration</p>
                            <p class="text-sm text-gray-500">Send welcome email to users after registration</p>
                        </div>
                        <label class="relative inline-flex items-center cursor-pointer">
                            <input type="hidden" name="notify_registration_enabled" value="0">
                            <input type="checkbox" name="notify_registration_enabled" value="1"
                                {{ old('notify_registration_enabled', $settings['notify_registration_enabled']) == '1' ? 'checked' : '' }}
                                class="sr-only peer">
                            <div class="w-11 h-6 bg-gray-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary/20 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
                        </label>
                    </div>

                    <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                        <div>
                            <p class="font-medium text-gray-800">Account Approval</p>
                            <p class="text-sm text-gray-500">Send notification when business account is approved</p>
                        </div>
                        <label class="relative inline-flex items-center cursor-pointer">
                            <input type="hidden" name="notify_approval_enabled" value="0">
                            <input type="checkbox" name="notify_approval_enabled" value="1"
                                {{ old('notify_approval_enabled', $settings['notify_approval_enabled']) == '1' ? 'checked' : '' }}
                                class="sr-only peer">
                            <div class="w-11 h-6 bg-gray-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary/20 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
                        </label>
                    </div>
                </div>
            </div>

            <div class="flex justify-end gap-4 pt-4 border-t">
                <a href="{{ route('admin.dashboard') }}"
                    class="px-6 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                    Cancel
                </a>
                <button type="submit"
                    class="bg-primary text-white px-6 py-2 rounded-lg hover:bg-primary-dark">
                    Save Settings
                </button>
            </div>
        </div>
    </form>

    <form method="POST" action="{{ route('admin.settings.test-mail') }}" class="bg-white rounded-lg shadow p-6">
        @csrf

        <h2 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
            <svg class="w-5 h-5 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Test Email
        </h2>

        <p class="text-sm text-gray-600 mb-4">Send a test email to verify your SMTP settings are working.</p>

        <div class="flex gap-4 items-end">
            <div class="flex-1">
                <label class="block text-sm font-medium text-gray-700 mb-1">Send test email to:</label>
                <input type="email" name="test_email" required
                    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary"
                    placeholder="test@email.com">
            </div>
            <button type="submit"
                class="bg-gray-600 text-white px-6 py-2 rounded-lg hover:bg-gray-700 whitespace-nowrap">
                Send Test
            </button>
        </div>
    </form>

    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <div class="flex">
            <svg class="w-5 h-5 text-blue-400 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
            </svg>
            <div class="ml-3">
                <h3 class="text-sm font-medium text-blue-800">How to configure</h3>
                <ul class="mt-2 text-sm text-blue-700 space-y-1">
                    <li>• <strong>Gmail:</strong> Use an App Password (not your regular password). Enable 2FA first.</li>
                    <li>• <strong>Host:</strong> smtp.gmail.com, <strong>Port:</strong> 587, <strong>Encryption:</strong> TLS</li>
                    <li>• Enable/disable individual email notifications using the toggles above</li>
                    <li>• Registration welcome and approval emails use the configured SMTP settings</li>
                </ul>
            </div>
        </div>
    </div>
</div>
@endsection

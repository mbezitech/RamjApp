@extends('admin.layout')

@section('title', 'Facilities')

@section('content')
    <div class="flex flex-col md:flex-row md:items-end justify-between gap-md mb-lg">
        <div>
            <h1 class="text-h1 text-on-surface tracking-tight font-bold">Facility Management</h1>
            <p class="text-body-md text-on-surface-variant">Oversee medical installations, manage administrative access, and monitor verification status across the network.</p>
        </div>
        <div class="flex gap-sm">
            <button class="flex items-center gap-xs px-sm py-base border border-outline-variant rounded-lg text-[11px] font-bold text-on-surface-variant bg-surface-container-lowest hover:bg-surface-container-low transition-colors">
                <span class="material-symbols-outlined text-[18px]">file_download</span>
                Export List
            </button>
            <button class="flex items-center gap-xs px-sm py-base bg-primary-container rounded-lg text-[11px] font-bold text-on-primary hover:bg-primary transition-colors">
                <span class="material-symbols-outlined text-[18px]">add</span>
                Register Facility
            </button>
        </div>
    </div>

    <!-- Stats Bento -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-md mb-xl">
        <div class="bg-surface-container-lowest border border-outline-variant p-md rounded-xl flex flex-col justify-between h-32">
            <div class="flex justify-between">
                <span class="text-on-surface-variant text-[11px] font-bold">Total Facilities</span>
                <span class="material-symbols-outlined text-primary">domain</span>
            </div>
            <span class="text-h2 text-on-surface font-bold">142</span>
        </div>
        <div class="bg-surface-container-lowest border border-outline-variant p-md rounded-xl flex flex-col justify-between h-32">
            <div class="flex justify-between">
                <span class="text-on-surface-variant text-[11px] font-bold">Verified</span>
                <span class="material-symbols-outlined text-secondary">verified</span>
            </div>
            <span class="text-h2 text-on-surface font-bold">128</span>
        </div>
        <div class="bg-surface-container-lowest border border-outline-variant p-md rounded-xl flex flex-col justify-between h-32">
            <div class="flex justify-between">
                <span class="text-on-surface-variant text-[11px] font-bold">Pending Review</span>
                <span class="material-symbols-outlined text-error">pending_actions</span>
            </div>
            <span class="text-h2 text-on-surface font-bold">14</span>
        </div>
        <div class="bg-surface-container-lowest border border-outline-variant p-md rounded-xl flex flex-col justify-between h-32">
            <div class="flex justify-between">
                <span class="text-on-surface-variant text-[11px] font-bold">System Alerts</span>
                <span class="material-symbols-outlined text-primary">warning</span>
            </div>
            <span class="text-h2 text-on-surface font-bold">3</span>
        </div>
    </div>

    <!-- Facilities Table -->
    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl overflow-hidden shadow-sm">
        <div class="p-sm border-b border-outline-variant flex flex-col md:flex-row gap-sm items-center justify-between">
            <div class="relative w-full md:w-96">
                <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-on-surface-variant text-[18px]">search</span>
                <input class="w-full pl-xl pr-sm py-base bg-surface-container-low border border-outline-variant rounded-lg text-sm focus:outline-none focus:border-primary transition-colors" placeholder="Search facilities, admins, or locations..." type="text">
            </div>
            <div class="flex gap-xs">
                <button class="px-sm py-base text-[11px] font-bold text-on-surface-variant hover:bg-surface-container-low rounded transition-colors flex items-center gap-xs">
                    <span class="material-symbols-outlined text-[18px]">filter_list</span>
                    Filter
                </button>
                <button class="px-sm py-base text-[11px] font-bold text-on-surface-variant hover:bg-surface-container-low rounded transition-colors flex items-center gap-xs">
                    <span class="material-symbols-outlined text-[18px]">sort</span>
                    Sort
                </button>
            </div>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full border-collapse">
                <thead>
                    <tr class="bg-surface-container-low text-left">
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant border-b border-outline-variant uppercase tracking-wider">Facility &amp; Admin</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant border-b border-outline-variant uppercase tracking-wider">Location</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant border-b border-outline-variant uppercase tracking-wider">Status</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant border-b border-outline-variant uppercase tracking-wider">Last Sync</th>
                        <th class="px-md py-sm text-[11px] font-bold text-on-surface-variant border-b border-outline-variant uppercase tracking-wider text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="text-sm zebra-table">
                    <tr class="hover:bg-surface-container-low transition-colors">
                        <td class="px-md py-md">
                            <div class="flex items-center gap-sm">
                                <div class="w-10 h-10 rounded-lg bg-secondary-container flex items-center justify-center shrink-0">
                                    <span class="material-symbols-outlined text-secondary">local_hospital</span>
                                </div>
                                <div>
                                    <p class="text-[11px] font-bold text-on-surface leading-tight">North Memorial Health</p>
                                    <p class="text-on-surface-variant text-[10px]">Admin: Dr. Sarah Chen</p>
                                </div>
                            </div>
                        </td>
                        <td class="px-md py-md">
                            <div class="flex items-center gap-xs">
                                <span class="material-symbols-outlined text-primary text-[14px]">location_on</span>
                                <span class="text-sm">Minneapolis, MN</span>
                            </div>
                        </td>
                        <td class="px-md py-md">
                            <span class="inline-flex items-center px-xs py-base rounded bg-emerald-100 text-emerald-700 text-[11px] font-bold gap-xs">
                                <span class="material-symbols-outlined text-[14px]" style="font-variation-settings: 'FILL' 1;">verified</span>
                                Verified
                            </span>
                        </td>
                        <td class="px-md py-md text-on-surface-variant text-sm">2 mins ago</td>
                        <td class="px-md py-md text-right">
                            <button class="text-primary text-[11px] font-bold hover:underline">Manage Access</button>
                        </td>
                    </tr>
                    <tr class="hover:bg-surface-container-low transition-colors">
                        <td class="px-md py-md">
                            <div class="flex items-center gap-sm">
                                <div class="w-10 h-10 rounded-lg bg-primary-fixed flex items-center justify-center shrink-0">
                                    <span class="material-symbols-outlined text-primary">emergency</span>
                                </div>
                                <div>
                                    <p class="text-[11px] font-bold text-on-surface leading-tight">Apex Urgent Care Center</p>
                                    <p class="text-on-surface-variant text-[10px]">Admin: Michael Ross</p>
                                </div>
                            </div>
                        </td>
                        <td class="px-md py-md">
                            <div class="flex items-center gap-xs">
                                <span class="material-symbols-outlined text-primary text-[14px]">location_on</span>
                                <span class="text-sm">Austin, TX</span>
                            </div>
                        </td>
                        <td class="px-md py-md">
                            <span class="inline-flex items-center px-xs py-base rounded bg-error-container text-on-error-container text-[11px] font-bold gap-xs">
                                <span class="material-symbols-outlined text-[14px]">schedule</span>
                                Pending
                            </span>
                        </td>
                        <td class="px-md py-md text-on-surface-variant text-sm">14 mins ago</td>
                        <td class="px-md py-md text-right">
                            <button class="px-sm py-base bg-primary-container text-on-primary rounded text-[11px] font-bold hover:bg-primary transition-colors">Verify Facility</button>
                        </td>
                    </tr>
                    <tr class="hover:bg-surface-container-low transition-colors">
                        <td class="px-md py-md">
                            <div class="flex items-center gap-sm">
                                <div class="w-10 h-10 rounded-lg bg-secondary-container flex items-center justify-center shrink-0">
                                    <span class="material-symbols-outlined text-secondary">biotech</span>
                                </div>
                                <div>
                                    <p class="text-[11px] font-bold text-on-surface leading-tight">City Diagnostic Lab</p>
                                    <p class="text-on-surface-variant text-[10px]">Admin: Elena Rodriguez</p>
                                </div>
                            </div>
                        </td>
                        <td class="px-md py-md">
                            <div class="flex items-center gap-xs">
                                <span class="material-symbols-outlined text-primary text-[14px]">location_on</span>
                                <span class="text-sm">Chicago, IL</span>
                            </div>
                        </td>
                        <td class="px-md py-md">
                            <span class="inline-flex items-center px-xs py-base rounded bg-emerald-100 text-emerald-700 text-[11px] font-bold gap-xs">
                                <span class="material-symbols-outlined text-[14px]" style="font-variation-settings: 'FILL' 1;">verified</span>
                                Verified
                            </span>
                        </td>
                        <td class="px-md py-md text-on-surface-variant text-sm">1 hour ago</td>
                        <td class="px-md py-md text-right">
                            <button class="text-primary text-[11px] font-bold hover:underline">Manage Access</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="p-sm border-t border-outline-variant flex items-center justify-between">
            <p class="text-sm text-on-surface-variant">Showing 1 to 3 of 142 entries</p>
            <div class="flex gap-xs">
                <button class="w-8 h-8 flex items-center justify-center rounded border border-outline-variant text-on-surface-variant hover:bg-surface-container-low">
                    <span class="material-symbols-outlined text-[18px]">chevron_left</span>
                </button>
                <button class="w-8 h-8 flex items-center justify-center rounded bg-primary-container text-on-primary text-[11px] font-bold">1</button>
                <button class="w-8 h-8 flex items-center justify-center rounded border border-outline-variant text-on-surface-variant hover:bg-surface-container-low text-[11px] font-bold">2</button>
                <button class="w-8 h-8 flex items-center justify-center rounded border border-outline-variant text-on-surface-variant hover:bg-surface-container-low">
                    <span class="material-symbols-outlined text-[18px]">chevron_right</span>
                </button>
            </div>
        </div>
    </div>

    <!-- Info Cards -->
    <div class="mt-lg grid grid-cols-1 md:grid-cols-2 gap-md">
        <div class="bg-surface-container-low p-md rounded-xl border border-outline-variant">
            <div class="flex items-center gap-sm mb-sm text-primary">
                <span class="material-symbols-outlined">info</span>
                <h3 class="text-[11px] font-bold uppercase">Verification Protocol</h3>
            </div>
            <p class="text-sm text-on-surface-variant leading-relaxed">Facilities pending verification must submit local licensing documentation before administrative access can be granted. System alerts will trigger if credentials expire within 30 days.</p>
        </div>
        <div class="bg-surface-container-low p-md rounded-xl border border-outline-variant">
            <div class="flex items-center gap-sm mb-sm text-secondary">
                <span class="material-symbols-outlined">security</span>
                <h3 class="text-[11px] font-bold uppercase">Access Security</h3>
            </div>
            <p class="text-sm text-on-surface-variant leading-relaxed">Admin roles are limited to two per facility. Any requests for additional oversight must be cleared through the regional clinical director's office and logged in the system audit.</p>
        </div>
    </div>
@endsection

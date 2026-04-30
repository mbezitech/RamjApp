<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'admin@ramjapp.com'],
            [
                'name' => 'Admin User',
                'email' => 'admin@ramjapp.com',
                'password' => Hash::make('admin123'),
                'role' => 'admin',
                'is_verified' => true,
                'phone' => '+255000000000',
            ]
        );

        User::updateOrCreate(
            ['email' => 'admin2@ramjapp.com'],
            [
                'name' => 'Super Admin',
                'email' => 'admin2@ramjapp.com',
                'password' => Hash::make('admin123'),
                'role' => 'admin',
                'is_verified' => true,
                'phone' => '+255000000001',
            ]
        );

        $this->command->info('Admin users created successfully!');
        $this->command->info('Email: admin@ramjapp.com | Password: admin123');
        $this->command->info('Email: admin2@ramjapp.com | Password: admin123');
    }
}

<?php

namespace Database\Seeders;

use App\Models\Product;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'name' => 'Admin User',
            'email' => 'admin@ramjapp.com',
            'password' => Hash::make('password'),
            'role' => 'admin',
            'is_verified' => true,
        ]);

        User::create([
            'name' => 'Regular Customer',
            'email' => 'customer@example.com',
            'password' => Hash::make('password'),
            'role' => 'customer',
            'is_verified' => false,
        ]);

        User::create([
            'name' => 'Verified Pharmacy',
            'email' => 'pharmacy@example.com',
            'password' => Hash::make('password'),
            'role' => 'business',
            'is_verified' => true,
            'business_name' => 'Dar es Salaam Pharmacy',
            'business_type' => 'pharmacy',
        ]);

        $equipment = [
            ['name' => 'Digital Blood Pressure Monitor', 'description' => 'Automatic upper arm BP monitor with large LCD display', 'category' => 'equipment', 'price' => 45000, 'stock' => 50],
            ['name' => 'Digital Thermometer', 'description' => 'Infrared non-contact thermometer', 'category' => 'equipment', 'price' => 15000, 'stock' => 100],
            ['name' => 'Pulse Oximeter', 'description' => 'Fingertip pulse oximeter for SpO2 and heart rate', 'category' => 'equipment', 'price' => 25000, 'stock' => 75],
            ['name' => 'Glucometer Kit', 'description' => 'Blood glucose monitoring kit with 10 test strips', 'category' => 'equipment', 'price' => 35000, 'stock' => 40],
            ['name' => 'Stethoscope', 'description' => 'Professional dual-head stethoscope', 'category' => 'equipment', 'price' => 28000, 'stock' => 60],
            ['name' => 'Nebulizer Machine', 'description' => 'Portable compressor nebulizer for respiratory therapy', 'category' => 'equipment', 'price' => 85000, 'stock' => 25],
        ];

        foreach ($equipment as $item) {
            Product::create(array_merge($item, ['requires_verification' => false]));
        }

        $medicines = [
            ['name' => 'Amoxicillin 500mg', 'description' => 'Antibiotic capsule - 21 capsules per pack', 'category' => 'medicine', 'price' => 12000, 'stock' => 200],
            ['name' => 'Paracetamol 500mg', 'description' => 'Pain relief and fever reducer - 20 tablets', 'category' => 'medicine', 'price' => 3000, 'stock' => 500],
            ['name' => 'Metformin 500mg', 'description' => 'Diabetes management tablet - 30 tablets', 'category' => 'medicine', 'price' => 8000, 'stock' => 150],
            ['name' => 'Omeprazole 20mg', 'description' => 'Acid reflux treatment - 14 capsules', 'category' => 'medicine', 'price' => 9500, 'stock' => 180],
            ['name' => 'Cetirizine 10mg', 'description' => 'Antihistamine for allergies - 10 tablets', 'category' => 'medicine', 'price' => 4000, 'stock' => 300],
        ];

        foreach ($medicines as $item) {
            Product::create(array_merge($item, ['requires_verification' => true]));
        }
    }
}

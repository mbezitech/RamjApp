<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_settings', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();
            $table->text('value')->nullable();
            $table->timestamps();
        });

        $defaults = [
            ['key' => 'smtp_host', 'value' => ''],
            ['key' => 'smtp_port', 'value' => '587'],
            ['key' => 'smtp_username', 'value' => ''],
            ['key' => 'smtp_password', 'value' => ''],
            ['key' => 'smtp_encryption', 'value' => 'tls'],
            ['key' => 'mail_from_address', 'value' => ''],
            ['key' => 'mail_from_name', 'value' => 'MedFootApp'],
        ];

        DB::table('app_settings')->insert($defaults);
    }

    public function down(): void
    {
        Schema::dropIfExists('app_settings');
    }
};

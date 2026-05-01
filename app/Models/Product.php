<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'category',
        'price',
        'stock',
        'image_url',
        'requires_verification',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'requires_verification' => 'boolean',
            'is_active' => 'boolean',
        ];
    }

    public function isMedicine(): bool
    {
        return $this->category === 'medicine' || $this->requires_verification;
    }

    public function isEquipment(): bool
    {
        return $this->category === 'equipment';
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }
}

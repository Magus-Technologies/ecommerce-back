<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserAddress extends Model
{
    // UserAddress.php
    protected $fillable = [
        'user_id',
        'label',
        'district', // si decides tenerlo
        'city',
        'province',
        'department',
        'postal_code',
        'country',
        'is_default',
    ];
    // app/Models/UserAddress.php
    public function user() {
        return $this->belongsTo(User::class);
    }
}

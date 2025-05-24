<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserProfile extends Model
{

    protected $fillable = [
        'user_id',
        'first_name',
        'last_name_father',
        'last_name_mother',
        'phone',
        'document_type',
        'document_number',
        'birth_date',
        'genero',
        'avatar_url',
    ];

    // app/Models/UserProfile.php
    public function user() {
        return $this->belongsTo(User::class);
    }

}

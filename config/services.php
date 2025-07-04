<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'postmark' => [
        'token' => env('POSTMARK_TOKEN'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'resend' => [
        'key' => env('RESEND_KEY'),
    ],

    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],
    'greenter' => [
        'fe_url' => env('GREENTER_FE_URL'),
        'fe_user' => env('GREENTER_FE_USER'),
        'fe_password' => env('GREENTER_FE_PASSWORD'),
        'cert_path' => storage_path('app/' . env('GREENTER_CERT_PATH')),
        'private_key_path' => storage_path('app/' . env('GREENTER_PRIVATE_KEY_PATH')),
    ],

    'company' => [
        'ruc' => env('COMPANY_RUC'),
        'name' => env('COMPANY_NAME'),
        'address' => env('COMPANY_ADDRESS'),
        'district' => env('COMPANY_DISTRICT'),
        'province' => env('COMPANY_PROVINCE'),
        'department' => env('COMPANY_DEPARTMENT'),
    ],
    'google' => [
        'client_id' => env('GOOGLE_CLIENT_ID'),
        'client_secret' => env('GOOGLE_CLIENT_SECRET'),
        'redirect' => env('GOOGLE_REDIRECT_URI'),
    ],

];

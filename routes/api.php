<?php
use App\Http\Controllers\AdminController;
use Illuminate\Support\Facades\Route;;

Route::post('/login',[AdminController::class,'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [AdminController::class, 'user']);
    Route::post('/logout', [AdminController::class, 'logout']);
});
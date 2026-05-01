<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ForgotPasswordController;
use App\Http\Controllers\Api\DocumentController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Middleware\EnsureVerifiedBusiness;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forgot-password', [ForgotPasswordController::class, 'sendResetLink']);
Route::post('/reset-password', [ForgotPasswordController::class, 'reset']);

Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);
    Route::get('/verification-status', [AuthController::class, 'verificationStatus']);

    Route::get('/products', [ProductController::class, 'index']);
    Route::get('/products/{product}', [ProductController::class, 'show']);

    Route::post('/documents/upload', [DocumentController::class, 'upload']);
    Route::get('/documents', [DocumentController::class, 'index']);

    Route::post('/orders', [OrderController::class, 'store']);
    Route::get('/orders', [OrderController::class, 'index']);
    Route::get('/orders/{order}', [OrderController::class, 'show']);

    Route::middleware(EnsureVerifiedBusiness::class)->group(function () {
        Route::get('/products/medicines', [ProductController::class, 'index']);
    });

    Route::prefix('admin')->group(function () {
        Route::post('/products', [ProductController::class, 'store']);
        Route::put('/products/{product}', [ProductController::class, 'update']);
        Route::delete('/products/{product}', [ProductController::class, 'destroy']);

        Route::get('/documents/pending', [DocumentController::class, 'pending']);
        Route::post('/documents/{document}/review', [DocumentController::class, 'review']);

        Route::put('/orders/{order}/status', [OrderController::class, 'updateStatus']);
    });
});

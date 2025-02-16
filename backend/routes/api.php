<?php

use App\Http\Controllers\Admin\Report\AdminReportFollowUpController;
use App\Http\Controllers\Auth\ForgotPasswordController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\ResetPasswordController;
use App\Http\Controllers\User\Profile\UserProfileController;
use App\Http\Controllers\User\Report\UserReportController;
use App\Http\Controllers\User\Report\UserReportFollowUpController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/login', [LoginController::class, 'login']);
Route::post('/register', [RegisterController::class, 'register']);
Route::post('/forgot-password', [ForgotPasswordController::class, 'sendResetLinkEmail'])->name('password.email');
Route::post('/reset-password', [ResetPasswordController::class, 'reset'])->name('password.update');

Route::middleware(['auth:api'])->post('/logout', [LoginController::class, 'logout']);

Route::get('/reports/{id}', [UserReportController::class, 'show']);

Route::middleware(['auth:api', 'user-access:user'])->group(function () {
    Route::get('/user/profile', action: [UserProfileController::class, 'showProfile']);
    Route::post('/user/profile', [UserProfileController::class, 'storeProfile']);
    Route::post('/user/profile/update', [UserProfileController::class, 'updateProfile']);
    Route::post('/profile/change-password', [UserProfileController::class, 'changePassword']);


    Route::post('/report', [UserReportController::class, 'store']); 
    Route::put('/reports/{id}', [UserReportController::class, 'update']); 
    Route::delete('/report-attachments/{id}', [UserReportController::class, 'deleteAttachment']);


    Route::post('/user/reports/{id}/follow-ups', [UserReportFollowUpController::class, 'addFollowUp']);
    Route::get('/user/reports/{id}/follow-ups', [UserReportFollowUpController::class, 'getFollowUps']);
    Route::delete('/user/follow-ups/{id}', [UserReportFollowUpController::class, 'deleteFollowUp']);
});

Route::middleware(['auth:api', 'user-access:admin'])->group(function () {
    Route::post('/admin/reports/{id}/follow-ups', [AdminReportFollowUpController::class, 'addFollowUp']);
    Route::get('/admin/reports/{id}/follow-ups', [AdminReportFollowUpController::class, 'getFollowUps']);
    Route::delete('/admin/follow-ups/{id}', [AdminReportFollowUpController::class, 'deleteFollowUp']);
});
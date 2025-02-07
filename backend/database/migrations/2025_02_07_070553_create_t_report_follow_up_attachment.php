<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('t_report_follow_up_attachment', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('report_follow_up_id');
            $table->unsignedBigInteger('user_id');
            $table->string('file', 255); // Path file yang diunggah
            $table->timestamps();
            
            // Foreign keys
            $table->foreign('report_follow_up_id')->references('id')->on('t_report_follow_up')->onDelete('cascade');
            $table->foreign('user_id')->references('id')->on('t_user')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('t_report_follow_up_attachment');
    }
};

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
        Schema::create('t_user_info', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('full_name');
            $table->text('address')->nullable();
            $table->string('phone_number');
            $table->date('birth_date');
            $table->enum('gender', ['male', 'female']);
            $table->string('profile_picture')->nullable();
            $table->string('job')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('t_user')->onDelete('cascade');            
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('t_user_info');
    }
};

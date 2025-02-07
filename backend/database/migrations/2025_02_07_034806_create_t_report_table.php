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
        Schema::create('t_report', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('report_number', 20)->unique(); // Panjang lebih fleksibel
            $table->string('title', 255);
            $table->text('description');
            $table->date('date');
            $table->enum('status', ['pending', 'verified', 'in_progress', 'completed', 'closed'])->default('pending');
            $table->integer('likes')->default(0);
            
            // Lokasi laporan
            $table->string('district', 100); // Kecamatan
            $table->string('village', 100);  // Desa/Kelurahan
            $table->text('location_details')->nullable(); // Detail lokasi opsional
            
            $table->foreign('user_id')->references('id')->on('t_user')->onDelete('cascade');            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('t_report');
    }
};

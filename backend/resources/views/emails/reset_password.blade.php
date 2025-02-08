<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
            text-align: center;
        }
        .email-container {
            max-width: 600px;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            margin: auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .logo-container {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            margin-bottom: 20px;
        }
        .logo {
            max-width: 100px;
            width: 100%;
            height: auto;
        }
        .org-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-top: 5px;
        }
        .reset-button {
            display: inline-block;
            padding: 12px 20px;
            margin-top: 15px;
            font-size: 16px;
            color: white;
            background: #007bff;
            text-decoration: none;
            border-radius: 5px;
            width: 100%;
            max-width: 250px;
        }
        .text-muted {
            font-size: 14px;
            color: #666;
        }
        .break-word {
            word-break: break-word;
        }
        
        /* Responsiveness */
        @media (max-width: 480px) {
            .email-container {
                padding: 15px;
                width: 90%;
            }
            .reset-button {
                font-size: 14px;
                padding: 10px;
            }
            .text-muted {
                font-size: 13px;
            }
        }
    </style>
</head>
<body>
    <div class="email-container">
        <!-- Logo + Nama Organisasi -->
        <div class="logo-container">
            <img class="logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Seal_of_Toba_Regency_%282020%29.svg/1200px-Seal_of_Toba_Regency_%282020%29.svg.png" 
                 alt="Logo Toba Regency">
            <div class="org-name">Dinas Lingkungan Hidup <br> Kabupaten Toba</div>
        </div>

        <h2 style="color: #333;">Reset Password</h2>

        <p class="text-muted">
            Klik tombol di bawah untuk mengatur ulang password Anda:
        </p>

        <a href="{{ $resetUrl }}" class="reset-button">
            Reset Password
        </a>

        <p class="text-muted" style="margin-top: 20px;">
            Jika Anda tidak meminta reset password, abaikan email ini.
        </p>

        <p class="text-muted break-word">
            Jika mengalami masalah dengan tombol di atas, silakan klik link berikut atau salin ke browser Anda:<br>
            <a href="{{ $resetUrl }}" style="color: #007bff;">{{ $resetUrl }}</a>
        </p>
    </div>
</body>
</html>

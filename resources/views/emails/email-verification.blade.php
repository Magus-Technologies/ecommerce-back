<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verifica tu cuenta en MarketPro</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .logo { font-size: 28px; font-weight: bold; margin-bottom: 10px; }
        .content { padding: 30px 20px; }
        .verification-box { background: #f8f9ff; padding: 25px; border-radius: 8px; border: 2px solid #667eea; margin: 25px 0; text-align: center; }
        .btn { display: inline-block; background: #667eea; color: white; padding: 15px 30px; text-decoration: none; border-radius: 6px; margin: 20px 0; font-weight: bold; }
        .footer { background: #f8f9fa; padding: 20px; text-align: center; color: #666; border-radius: 0 0 10px 10px; }
        .warning { background: #fff3cd; padding: 15px; border-radius: 6px; border-left: 4px solid #ffc107; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">🎮 MarketPro</div>
            <p>Verificación de cuenta</p>
        </div>
        
        <div class="content">
            <h2>¡Hola {{ $user->nombres }}! 👋</h2>
            
            <p>Gracias por registrarte en <strong>MarketPro</strong>. Para completar tu registro y comenzar a disfrutar de las mejores ofertas en tecnología gaming, necesitamos verificar tu dirección de correo electrónico.</p>
            
            <div class="verification-box">
                <h3>🔐 Verifica tu cuenta</h3>
                <p>Haz clic en el botón de abajo para verificar tu cuenta:</p>
                <a href="{{ $verificationUrl }}" class="btn">✅ Verificar mi cuenta</a>
            </div>

            <div class="warning">
                <strong>⚠️ Importante:</strong> Este enlace de verificación expirará en 24 horas por seguridad.
            </div>

            <p>Una vez verificada tu cuenta, podrás:</p>
            <ul>
                <li>🛒 Realizar compras en nuestra tienda</li>
                <li>🎁 Acceder a ofertas exclusivas</li>
                <li>📦 Hacer seguimiento a tus pedidos</li>
                <li>⭐ Guardar productos en tu lista de deseos</li>
            </ul>

            <p>Si no solicitaste esta cuenta, simplemente ignora este correo.</p>
            
            <p><strong>El equipo de MarketPro</strong></p>
        </div>
        
        <div class="footer">
            <p>MarketPro - Tu partner en tecnología gaming</p>
            <p>Este correo fue enviado a {{ $user->email }}</p>
            <p>© 2024 MarketPro. Todos los derechos reservados.</p>
        </div>
    </div>
</body>
</html>

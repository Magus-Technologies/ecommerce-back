<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>¡Bienvenido a MarketPro!</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .logo { font-size: 28px; font-weight: bold; margin-bottom: 10px; }
        .content { padding: 30px 20px; }
        .highlight { background: #f8f9ff; padding: 20px; border-radius: 8px; border-left: 4px solid #667eea; margin: 20px 0; }
        .products { display: flex; justify-content: space-around; margin: 30px 0; }
        .product { text-align: center; padding: 15px; }
        .product img { width: 80px; height: 80px; border-radius: 8px; }
        .btn { display: inline-block; background: #667eea; color: white; padding: 12px 30px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
        .footer { background: #f8f9fa; padding: 20px; text-align: center; color: #666; border-radius: 0 0 10px 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">🎮 MarketPro</div>
            <p>Tu tienda especializada en tecnología gaming</p>
        </div>
        
        <div class="content">
            <h2>¡Hola {{ $user->nombres ?? $user->name }}! 👋</h2>
            
            <p>¡Bienvenido a <strong>MarketPro</strong>! Nos emociona tenerte como parte de nuestra comunidad de gamers y tech lovers.</p>
            
            <div class="highlight">
                <h3>🚀 ¿Qué puedes encontrar en MarketPro?</h3>
                <ul>
                    <li><strong>🎮 Gaming:</strong> Tarjetas gráficas de última generación, periféricos gaming, y accesorios</li>
                    <li><strong>💻 Laptops:</strong> Equipos de alto rendimiento para gaming y trabajo profesional</li>
                    <li><strong>🖥️ Componentes:</strong> Procesadores, RAM, almacenamiento y todo para tu build</li>
                    <li><strong>⚡ Accesorios:</strong> Teclados mecánicos, mouse gaming, headsets y más</li>
                </ul>
            </div>

            <div class="products">
                <div class="product">
                    <img src="https://images.pexels.com/photos/2399840/pexels-photo-2399840.jpeg?auto=compress&cs=tinysrgb&w=150" alt="Gaming Setup">
                    <p>Setups Gaming</p>
                </div>
                <div class="product">
                    <img src="https://images.pexels.com/photos/18105/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=150" alt="Laptops">
                    <p>Laptops Gaming</p>
                </div>
                <div class="product">
                    <img src="https://images.pexels.com/photos/2148217/pexels-photo-2148217.jpeg?auto=compress&cs=tinysrgb&w=150" alt="Componentes">
                    <p>Componentes PC</p>
                </div>
            </div>

            <div style="text-align: center;">
                <a href="https://magus-ecommerce.com/" class="btn">🛒 Explorar Productos</a>
            </div>

            <div class="highlight">
                <h3>🎁 Oferta de Bienvenida</h3>
                <p>Como nuevo miembro, obtén <strong>10% de descuento</strong> en tu primera compra con el código:</p>
                <p style="font-size: 20px; font-weight: bold; color: #667eea; text-align: center;">BIENVENIDO10</p>
            </div>

            <p>Si tienes alguna pregunta, nuestro equipo de expertos está aquí para ayudarte. ¡No dudes en contactarnos!</p>
            
            <p>¡Que tengas un excelente día gaming! 🎮</p>
            
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

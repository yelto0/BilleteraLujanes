<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Billetera Lujanes</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            -webkit-tap-highlight-color: transparent;
        }

        html, body {
            height: 100vh;
            width: 100vw;
            background-color: #58157A;
            overflow: hidden;
        }

        body {
            display: flex;
            flex-direction: column;
        }

        .header {
            display: flex;
            justify-content: flex-end;
            padding: 15px 20px 5px;
            flex-shrink: 0;
        }

        .btn-ayuda {
            background: rgba(255, 255, 255, 0.25);
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 20px;
            font-size: 15px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .qr-section {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 15px 0 25px;
            flex-shrink: 0;
        }

        .qr-card {
            background: white;
            padding: 16px;
            border-radius: 28px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            width: 210px;
            height: 210px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .qr-card img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        /* Formulario extendido */
        .main-card {
            background: white;
            border-top-left-radius: 36px;
            border-top-right-radius: 36px;
            padding: 28px 24px 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 -5px 25px rgba(0,0,0,0.1);
        }

        .title {
            color: #3B1152;
            font-size: 22px;
            font-weight: 700;
        }

        .input-alias {
            width: 100%;
            max-width: 330px;
            padding: 14px 18px;
            border: 1px solid #E2E8F0;
            border-radius: 14px;
            font-size: 15px;
            text-align: center;
            outline: none;
            color: #333;
            background-color: #FAFAFA;
        }

        .dots-container {
            display: flex;
            gap: 14px;
            margin: 5px 0;
        }

        .dot {
            width: 14px;
            height: 14px;
            border-radius: 50%;
            background-color: #E2E8F0;
            transition: background-color 0.2s ease;
        }

        .dot.active {
            background-color: #58157A;
        }

        .keypad {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            width: 100%;
            max-width: 340px;
        }

        .key {
            background: #F4F4F6;
            border: none;
            border-radius: 16px;
            height: 58px;
            font-size: 22px;
            font-weight: 600;
            color: #2D3748;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            user-select: none;
        }

        .key:active {
            background: #E2E8F0;
        }

        .key-action {
            background: transparent;
            font-size: 20px;
        }

        .forgot-link {
            color: #00C9A7;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            padding-bottom: 5px;
        }
    </style>
</head>
<body>

    <div class="header">
        <button type="button" class="btn-ayuda">🎧 Ayuda</button>
    </div>

    <div class="qr-section">
        <div class="qr-card">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=BilleteraLujanes" alt="QR Code">
        </div>
    </div>

    <!-- Formulario que apunta directamente a tu LoginServlet -->
    <form id="loginForm" action="login" method="POST" class="main-card">
        <h2 class="title">Ingresa tu clave</h2>

        <!-- Campos enviados al Servlet -->
        <input type="text" id="inputAlias" name="alias" class="input-alias" placeholder="Alias de usuario (ej: @carlos)" required>
        <input type="hidden" id="inputPin" name="clave">

        <div class="dots-container">
            <div class="dot"></div>
            <div class="dot"></div>
            <div class="dot"></div>
            <div class="dot"></div>
            <div class="dot"></div>
            <div class="dot"></div>
        </div>

        <div class="keypad">
            <button type="button" class="key" onclick="pressKey('5')">5</button>
            <button type="button" class="key" onclick="pressKey('7')">7</button>
            <button type="button" class="key" onclick="pressKey('1')">1</button>
            <button type="button" class="key" onclick="pressKey('3')">3</button>
            <button type="button" class="key" onclick="pressKey('0')">0</button>
            <button type="button" class="key" onclick="pressKey('6')">6</button>
            <button type="button" class="key" onclick="pressKey('2')">2</button>
            <button type="button" class="key" onclick="pressKey('4')">4</button>
            <button type="button" class="key" onclick="pressKey('8')">8</button>
            <button type="button" class="key key-action">🖐️</button>
            <button type="button" class="key" onclick="pressKey('9')">9</button>
            <button type="button" class="key key-action" onclick="deleteKey()">⌫</button>
        </div>

        <a href="registro.jsp" class="forgot-link">¿OLVIDASTE TU CLAVE?</a>
    </form>

    <script>
        let pin = "";
        const maxPinLength = 6;
        const dots = document.querySelectorAll('.dot');

        function pressKey(num) {
            if (pin.length < maxPinLength) {
                pin += num;
                updateDots();
                
                // Al completar los 6 dígitos se envía al Servlet automáticamente
                if (pin.length === maxPinLength) {
                    document.getElementById('inputPin').value = pin;
                    setTimeout(() => {
                        document.getElementById('loginForm').submit();
                    }, 200);
                }
            }
        }

        function deleteKey() {
            if (pin.length > 0) {
                pin = pin.slice(0, -1);
                updateDots();
            }
        }

        function updateDots() {
            dots.forEach((dot, index) => {
                if (index < pin.length) {
                    dot.classList.add('active');
                } else {
                    dot.classList.remove('active');
                }
            });
        }
    </script>

</body>
</html>
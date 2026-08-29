<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voucher Lujaneo</title>
    <!-- Librería para la animación de Confeti -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>

    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; }
        body {
            background-color: #4a0072;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .voucher-card {
            width: 100%;
            max-width: 380px;
            background-color: #4a0072;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.4);
            position: relative;
        }

        /* Cabecera con foto del personaje */
        .voucher-header {
            background: linear-gradient(180deg, #6a008a 0%, #4a0072 100%);
            padding: 30px 20px 20px 20px;
            text-align: center;
            position: relative;
        }

        .btn-close {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255,255,255,0.2);
            color: white;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-weight: bold;
        }

        .avatar-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 3px solid #00bfa5;
            margin: 0 auto 10px auto;
            overflow: hidden;
            box-shadow: 0 0 15px rgba(0, 191, 165, 0.5);
        }

        .avatar-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .header-title {
            color: #ffffff;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* Cuerpo Blanco del Voucher */
        .voucher-body {
            background-color: #ffffff;
            border-radius: 24px 24px 0 0;
            padding: 25px 20px;
        }

        .voucher-status {
            color: #5c128c;
            font-size: 22px;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .voucher-monto {
            font-size: 36px;
            font-weight: 900;
            color: #212121;
            margin-bottom: 10px;
        }

        .voucher-receptor {
            font-size: 18px;
            font-weight: 700;
            color: #424242;
            margin-bottom: 5px;
        }

        .voucher-fecha {
            font-size: 12px;
            color: #757575;
            margin-bottom: 20px;
        }

        .code-box {
            background-color: #f5f5f5;
            padding: 10px 15px;
            border-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
            color: #616161;
            margin-bottom: 20px;
        }

        .code-digits {
            display: flex;
            gap: 6px;
        }

        .digit {
            background: white;
            padding: 4px 8px;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
        }
    </style>
</head>
<body>
    <div class="voucher-card">
        <!-- Cabecera con foto del cocodrilo -->
        <div class="voucher-header">
            <a href="index.jsp" class="btn-close">✕</a>
            <div class="avatar-circle">
                <img src="${pageContext.request.contextPath}/images/personaje.jpg" alt="Lujaneo Avatar">
            </div>
            <div class="header-title">LUJANEO CONFIRMADO</div>
        </div>

        <!-- Cuerpo del Voucher -->
        <div class="voucher-body">
            <div class="voucher-status">¡Lujaneaste!</div>
            <div class="voucher-monto">LJ/ <%= request.getAttribute("monto") != null ? request.getAttribute("monto") : "0.00" %></div>
            <div class="voucher-receptor"><%= request.getAttribute("receptor") != null ? request.getAttribute("receptor") : "Usuario" %></div>
            <div class="voucher-fecha">Reciente | <%= new java.text.SimpleDateFormat("dd MMM yyyy - h:mm a").format(new java.util.Date()) %></div>

            <div class="code-box">
                <span>CÓDIGO DE SEGURIDAD</span>
                <div class="code-digits">
                    <span class="digit">6</span>
                    <span class="digit">3</span>
                    <span class="digit">5</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Animación de Confeti solo para quien envía el dinero
            if (typeof confetti === 'function') {
                confetti({
                    particleCount: 120,
                    spread: 80,
                    origin: { y: 0.4 },
                    colors: ['#00bfa5', '#ffd54f', '#ab47bc']
                });
            }
        });
    </script>
</body>
</html>
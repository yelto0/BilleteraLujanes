<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lujanes.model.Usuario"%>
<%@page import="com.lujanes.model.Transaccion"%>
<%@page import="com.lujanes.dao.BilleteraDAO"%>
<%@page import="java.util.List"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    BilleteraDAO dao = new BilleteraDAO();
    
    try {
        Usuario usuarioActualizado = dao.autenticar(usuario.getAlias(), usuario.getClave());
        if (usuarioActualizado != null) {
            usuario.setSaldoLujanes(usuarioActualizado.getSaldoLujanes());
            session.setAttribute("usuarioLogueado", usuario);
        }
    } catch (Exception e) {}

    List<Transaccion> listaMovimientos = null;
    try {
        listaMovimientos = dao.obtenerHistorial(usuario.getId()); 
    } catch (Exception e) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Billetera Lujanes</title>
    
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>

    <style>
        * { 
            box-sizing: border-box; 
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            margin: 0;
            padding: 0;
        }

        html, body {
            width: 100vw;
            min-height: 100vh;
            background-color: #5c128c;
            overflow-x: hidden;
        }

        .app-container {
            width: 100%;
            min-height: 100vh;
            background: linear-gradient(180deg, #5c128c 0%, #38006b 100%);
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
        }

        .notification-toast {
            display: none;
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: #00bfa5;
            color: #ffffff;
            padding: 16px 22px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,191,165,0.4);
            z-index: 9999;
            font-weight: 800;
            font-size: 15px;
            text-align: center;
            animation: bounceIn 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        @keyframes bounceIn {
            0% { top: -80px; opacity: 0; transform: translateX(-50%) scale(0.8); }
            70% { top: 25px; transform: translateX(-50%) scale(1.05); }
            100% { top: 20px; opacity: 1; transform: translateX(-50%) scale(1); }
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 20px;
            color: white;
            width: 100%;
        }
        .top-bar-left { display: flex; align-items: center; gap: 10px; }
        .icon-logout { font-size: 22px; cursor: pointer; transition: transform 0.2s; }
        .icon-logout:hover { transform: scale(1.2); }
        .user-greeting { font-size: 21px; font-weight: 800; letter-spacing: -0.5px; }
        .badge-gratis {
            background-color: #ffd54f;
            color: #1b003a;
            font-size: 11px;
            font-weight: 900;
            padding: 3px 10px;
            border-radius: 12px;
            text-transform: uppercase;
        }

        .btn-mi-qr-top {
            display: flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(5px);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-mi-qr-top:hover { background: rgba(255, 255, 255, 0.35); transform: translateY(-1px); }

        .main-card {
            background-color: #ffffff;
            flex: 1;
            width: 100%;
            border-radius: 28px 28px 0 0;
            padding: 22px 20px 100px 20px;
            margin-top: 5px;
            box-shadow: 0 -5px 15px rgba(0,0,0,0.1);
        }

        .saldo-box {
            background: #fcfaff;
            border: 1.5px solid #e1bee7;
            border-radius: 18px;
            padding: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 12px rgba(92, 18, 140, 0.05);
            cursor: pointer;
            margin-bottom: 20px;
            transition: background 0.2s;
        }
        .saldo-box:hover { background: #f3e5f5; }
        .saldo-left { display: flex; align-items: center; gap: 12px; color: #4a148c; font-weight: 800; font-size: 16px; }
        .saldo-value { font-size: 22px; font-weight: 900; color: #00bfa5; display: none; }

        .yape-form {
            display: none;
            background: #fafafa;
            padding: 18px;
            border-radius: 16px;
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
        }
        .yape-form input {
            width: 100%;
            padding: 12px 14px;
            margin-bottom: 8px;
            border: 1.5px solid #ccc;
            border-radius: 10px;
            outline: none;
            font-size: 14px;
            transition: border-color 0.2s;
        }
        .yape-form input:focus { border-color: #00bfa5; }
        
        .valid-feedback {
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 10px;
            min-height: 16px;
        }
        .valid-feedback.error { color: #d32f2f; }
        .valid-feedback.ok { color: #388e3c; }

        .yape-form button {
            width: 100%;
            padding: 14px;
            background-color: #00bfa5;
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 800;
            font-size: 15px;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .yape-form button:disabled { background-color: #b0bec5; cursor: not-allowed; }

        .movimientos-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .movimientos-title { color: #4a148c; font-size: 18px; font-weight: 800; }
        .movimientos-right { display: flex; align-items: center; gap: 15px; }
        .icon-refresh { color: #00bfa5; font-size: 18px; cursor: pointer; }
        .btn-ver-todos { color: #00bfa5; font-weight: 800; font-size: 13px; cursor: pointer; }

        .movimientos-lista { max-height: 250px; overflow-y: hidden; transition: max-height 0.3s ease-in-out; }
        .movimientos-lista.expandido { max-height: 600px; overflow-y: auto; }

        .movimiento-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .mov-left { display: flex; align-items: center; gap: 12px; }
        .mov-icon {
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px; font-weight: bold;
        }
        .mov-icon.enviado { background-color: #fce4ec; color: #c2185b; }
        .mov-icon.recibido { background-color: #e0f2f1; color: #00796b; }
        .mov-nombre { font-size: 14px; font-weight: 700; color: #333333; }
        .mov-fecha { font-size: 11px; color: #888888; margin-top: 2px; }
        .mov-monto { font-size: 15px; font-weight: 800; }
        .mov-monto.enviado { color: #d32f2f; }
        .mov-monto.recibido { color: #00bfa5; }

        .qr-modal {
            display: none; background: #fdfbfd; border: 2px solid #e1bee7;
            border-radius: 18px; padding: 20px; text-align: center; margin-bottom: 20px;
        }
        .qr-modal img { width: 160px; height: 160px; border-radius: 12px; }

        /* Estilos modernos del escáner */
        .scanner-modal {
            display: none;
            position: relative;
            background: #000;
            border-radius: 20px;
            padding: 15px;
            text-align: center;
            margin-bottom: 20px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .scanner-title-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .scanner-title {
            color: #00bfa5;
            font-weight: 800;
            font-size: 16px;
        }

        .btn-close-scanner {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            font-size: 16px;
            cursor: pointer;
        }

        #reader select, #reader button, #reader__dashboard_section_csr {
            display: none !important;
        }

        #reader video {
            width: 100% !important;
            height: 240px !important;
            object-fit: cover !important;
            border-radius: 14px;
        }

        #reader {
            border: none !important;
            background: transparent !important;
        }

        .bottom-actions {
            position: fixed; bottom: 0; left: 0; width: 100vw;
            background-color: #ffffff; padding: 15px 20px 20px 20px;
            box-sizing: border-box; display: flex; gap: 12px; border-top: 1px solid #f0f0f0;
            z-index: 1000;
        }
        .btn-qr, .btn-yapear {
            flex: 1; border-radius: 14px; padding: 14px 0; font-weight: 800; font-size: 13px;
            display: flex; align-items: center; justify-content: center; gap: 6px; cursor: pointer;
        }
        .btn-qr { background-color: #ffffff; color: #00bfa5; border: 2px solid #00bfa5; }
        .btn-yapear { background-color: #00bfa5; color: #ffffff; border: none; }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Toast de Notificación -->
        <div id="toastNotificacion" class="notification-toast">
            🎉 ¡Te Lujanearon! Recibiste <span id="montoRecibido">LJ/ 0.00</span>
        </div>

        <!-- Audio de Notificación para el RECEPTOR -->
        <audio id="audioLujaneo" src="${pageContext.request.contextPath}/audio/Lujaneo.mp3" preload="auto"></audio>

        <!-- Barra Superior -->
        <div class="top-bar">
            <div class="top-bar-left">
                <span class="icon-logout" title="Cerrar Sesión" onclick="location.href='${pageContext.request.contextPath}/logout'">🚪</span>
                <span class="user-greeting">Hola, <%= usuario.getNombre().split(" ")[0] %></span>
                <span class="badge-gratis">Gratis</span>
            </div>
            <div class="top-bar-right">
                <div class="btn-mi-qr-top" onclick="toggleQRPersonal()">
                    <span>⚃</span>
                    <span>Mi QR</span>
                </div>
            </div>
        </div>

        <!-- Tarjeta Principal -->
        <div class="main-card">
            <!-- Consultar Saldo -->
            <div class="saldo-box" onclick="toggleSaldo()">
                <div class="saldo-left">
                    <span id="eye-icon">👁️</span>
                    <span id="saldo-text">Mostrar saldo</span>
                </div>
                <div class="saldo-value" id="saldo-value">
                    LJ/ <%= String.format("%.2f", usuario.getSaldoLujanes()) %>
                </div>
            </div>

            <!-- Modal QR Personal -->
            <div class="qr-modal" id="qrModal">
                <h4 style="color:#5c128c; margin:0 0 10px 0;">Mi Código QR Personal</h4>
                <img id="qrImage" src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=<%= usuario.getAlias() %>" crossorigin="anonymous">
            </div>

            <!-- Modal Escáner QR Moderno -->
            <div class="scanner-modal" id="scannerModal">
                <div class="scanner-title-container">
                    <span class="scanner-title">Escaneando código QR...</span>
                    <button type="button" class="btn-close-scanner" onclick="detenerEscaneo()">✕</button>
                </div>
                <div id="reader"></div>
            </div>

            <!-- Formulario Lujanear -->
            <div class="yape-form" id="yapeForm">
                <form action="transferir" method="POST" onsubmit="return validarFormulario()">
                    <input type="text" id="inputTelefono" name="telefonoReceptor" placeholder="Alias del receptor (ej: @carlos)" required>
                    <input type="number" step="0.01" id="inputMonto" name="monto" placeholder="Monto LJ/" required oninput="validarSaldoEnTiempoReal()">
                    
                    <div id="saldoFeedback" class="valid-feedback"></div>

                    <button type="submit" id="btnEnviarLujaneo">Confirmar Lujaneo</button>
                </form>
            </div>

            <!-- Cabecera Movimientos -->
            <div class="movimientos-header">
                <span class="movimientos-title">Movimientos</span>
                <div class="movimientos-right">
                    <span class="icon-refresh" onclick="location.reload()">🔄</span>
                    <span class="btn-ver-todos" id="btnVerTodos" onclick="toggleMovimientos()">VER TODOS</span>
                </div>
            </div>

            <!-- Lista de Movimientos -->
            <div class="movimientos-lista" id="listaMovimientos">
            <% 
                if (listaMovimientos != null && !listaMovimientos.isEmpty()) {
                    for (Transaccion t : listaMovimientos) {
                        double montoVal = 0.0;
                        String emisor = "";
                        String receptor = "";

                        try {
                            java.lang.reflect.Field[] fields = t.getClass().getDeclaredFields();
                            for (java.lang.reflect.Field f : fields) {
                                f.setAccessible(true);
                                String name = f.getName().toLowerCase();
                                if (name.contains("monto")) {
                                    Object val = f.get(t);
                                    if (val != null) montoVal = Double.parseDouble(val.toString());
                                } else if (name.contains("emisor")) {
                                    Object val = f.get(t);
                                    if (val != null) emisor = val.toString();
                                } else if (name.contains("receptor")) {
                                    Object val = f.get(t);
                                    if (val != null) receptor = val.toString();
                                }
                            }
                        } catch (Exception ex) {}

                        boolean esEnviado = emisor != null && esEnviado(emisor, usuario.getNombre());
                        String titulo = esEnviado ? "Lujaneaste a " + receptor : emisor + " te lujaneo";
                        String claseEstilo = esEnviado ? "enviado" : "recibido";
                        String signo = esEnviado ? "- " : "+ ";
                        String icono = esEnviado ? "↗" : "↙";
            %>
                <div class="movimiento-item">
                    <div class="mov-left">
                        <div class="mov-icon <%= claseEstilo %>"><%= icono %></div>
                        <div>
                            <div class="mov-nombre"><%= titulo %></div>
                            <div class="mov-fecha">Reciente</div>
                        </div>
                    </div>
                    <div class="mov-monto <%= claseEstilo %>">
                        <%= signo %>LJ/ <%= String.format("%.2f", montoVal) %>
                    </div>
                </div>
            <% 
                    }
                } else { 
            %>
                <div style="text-align:center; color:#888; font-size:13px;">No tienes movimientos recientes.</div>
            <% } %>
            </div>
        </div>

        <div class="bottom-actions">
            <button class="btn-yapear" onclick="toggleForm()">
                <span>✈</span> LUJANEAR
            </button>
            <button class="btn-qr" onclick="iniciarEscaneoQR()">
                <span>⚃</span> ESCANEA EL QR
            </button>
        </div>
    </div>

    <%!
        private boolean esEnviado(String emisor, String usuarioLogueado) {
            return emisor != null && emisor.equalsIgnoreCase(usuarioLogueado);
        }
    %>

    <script>
        const saldoDisponible = <%= usuario.getSaldoLujanes() %>;

        let audioDesbloqueado = false;
        function desbloquearAudio() {
            if (!audioDesbloqueado) {
                const audio = document.getElementById('audioLujaneo');
                if (audio) {
                    audio.play().then(() => {
                        audio.pause();
                        audio.currentTime = 0;
                        audioDesbloqueado = true;
                    }).catch(e => {});
                }
            }
        }
        document.addEventListener('click', desbloquearAudio, { once: true });
        document.addEventListener('touchstart', desbloquearAudio, { once: true });

        function validarSaldoEnTiempoReal() {
            const inputMonto = document.getElementById('inputMonto');
            const feedback = document.getElementById('saldoFeedback');
            const btn = document.getElementById('btnEnviarLujaneo');
            const montoIngresado = parseFloat(inputMonto.value);

            if (isNaN(montoIngresado) || montoIngresado <= 0) {
                feedback.className = "valid-feedback error";
                feedback.innerText = "Ingresa un monto válido mayor a 0.";
                btn.disabled = true;
            } else if (montoIngresado > saldoDisponible) {
                feedback.className = "valid-feedback error";
                feedback.innerText = "⚠️ Saldo insuficiente (Disponible: LJ/ " + saldoDisponible.toFixed(2) + ")";
                btn.disabled = true;
            } else {
                feedback.className = "valid-feedback ok";
                feedback.innerText = "✓ Saldo disponible suficiente";
                btn.disabled = false;
            }
        }

        function validarFormulario() {
            const inputMonto = parseFloat(document.getElementById('inputMonto').value);
            return !isNaN(inputMonto) && inputMonto > 0 && inputMonto <= saldoDisponible;
        }

        function reproducirSonidoReceptor() {
            const audio = document.getElementById('audioLujaneo');
            if (audio) {
                audio.currentTime = 0;
                audio.play().catch(err => console.log("Permiso de reproducción bloqueado:", err));
            }
            if (navigator.vibrate) {
                navigator.vibrate([100, 50, 100, 50, 200]);
            }
        }

        setInterval(function() {
            fetch('${pageContext.request.contextPath}/checkNotificacion')
                .then(response => response.json())
                .then(data => {
                    if (data.actualizado) {
                        reproducirSonidoReceptor();

                        const toast = document.getElementById('toastNotificacion');
                        document.getElementById('montoRecibido').innerText = 'LJ/ ' + data.monto.toFixed(2);
                        toast.style.display = 'block';

                        setTimeout(() => {
                            location.reload();
                        }, 3500);
                    }
                })
                .catch(err => {});
        }, 3000);

        let saldoVisible = false;
        let html5QrcodeScanner = null;

        function toggleSaldo() {
            saldoVisible = !saldoVisible;
            const saldoValue = document.getElementById('saldo-value');
            const saldoText = document.getElementById('saldo-text');
            const eyeIcon = document.getElementById('eye-icon');

            if (saldoVisible) {
                saldoValue.style.display = 'block';
                saldoText.style.display = 'none';
                eyeIcon.innerText = '🙈';
            } else {
                saldoValue.style.display = 'none';
                saldoText.style.display = 'inline';
                saldoText.innerText = 'Mostrar saldo';
                eyeIcon.innerText = '👁️';
            }
        }

        function toggleForm() {
            detenerEscaneo();
            document.getElementById('qrModal').style.display = 'none';
            const form = document.getElementById('yapeForm');
            form.style.display = (form.style.display === 'block') ? 'none' : 'block';
        }

        function toggleQRPersonal() {
            detenerEscaneo();
            document.getElementById('yapeForm').style.display = 'none';
            const modal = document.getElementById('qrModal');
            modal.style.display = (modal.style.display === 'block') ? 'none' : 'block';
        }

        function toggleMovimientos() {
            const lista = document.getElementById('listaMovimientos');
            const btn = document.getElementById('btnVerTodos');
            if (lista.classList.contains('expandido')) {
                lista.classList.remove('expandido');
                btn.innerText = 'VER TODOS';
            } else {
                lista.classList.add('expandido');
                btn.innerText = 'VER MENOS';
            }
        }

        function iniciarEscaneoQR() {
            document.getElementById('qrModal').style.display = 'none';
            document.getElementById('yapeForm').style.display = 'none';
            const scannerModal = document.getElementById('scannerModal');
            
            if (scannerModal.style.display === 'block') {
                detenerEscaneo();
                return;
            }

            scannerModal.style.display = 'block';

            if (!html5QrcodeScanner) {
                html5QrcodeScanner = new Html5Qrcode("reader");
            }

            const config = { fps: 10, qrbox: { width: 180, height: 180 } };
            
            html5QrcodeScanner.start(
                { facingMode: "environment" },
                config,
                onScanSuccess,
                onScanError
            ).catch(err => {
                html5QrcodeScanner.start({ facingMode: "user" }, config, onScanSuccess, onScanError);
            });
        }

        function onScanSuccess(decodedText) {
            detenerEscaneo();
            document.getElementById('inputTelefono').value = decodedText;
            document.getElementById('yapeForm').style.display = 'block';
        }

        function onScanError(errorMessage) {}

        function detenerEscaneo() {
            if (html5QrcodeScanner && html5QrcodeScanner.isScanning) {
                html5QrcodeScanner.stop().then(() => {
                    document.getElementById('scannerModal').style.display = 'none';
                }).catch(err => {
                    document.getElementById('scannerModal').style.display = 'none';
                });
            } else {
                document.getElementById('scannerModal').style.display = 'none';
            }
        }
    </script>
</body>
</html>
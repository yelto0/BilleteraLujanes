<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear cuenta - Lujanes</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #5c128c;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .container {
            width: 360px;
            background: #ffffff;
            border-radius: 24px;
            padding: 30px 25px;
            box-sizing: border-box;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .logo { font-size: 28px; font-weight: 900; color: #7b1fa2; margin-bottom: 5px; }
        .subtitle { font-size: 13px; color: #666; margin-bottom: 25px; }
        label { display: block; text-align: left; font-size: 12px; color: #4a148c; margin-bottom: 4px; font-weight: 700; }
        input {
            width: 100%; padding: 12px; margin-bottom: 15px; border-radius: 10px;
            border: 1px solid #ccc; font-size: 14px; box-sizing: border-box; outline: none;
        }
        input:focus { border-color: #00bfa5; box-shadow: 0 0 0 2px rgba(0, 191, 165, 0.2); }
        button {
            width: 100%; padding: 14px; margin-top: 10px; border-radius: 10px; border: none;
            background-color: #00bfa5; color: #ffffff; font-size: 16px; font-weight: 800; cursor: pointer;
        }
        button:hover { background-color: #00a892; }
        .login-link { display: block; margin-top: 20px; color: #7b1fa2; text-decoration: none; font-size: 13px; font-weight: 700; }
        .error { color: #d32f2f; font-size: 13px; margin-top: 10px; font-weight: 600; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Lujanes</div>
        <div class="subtitle">Regístrate y crea tu Alias único</div>

        <form action="${pageContext.request.contextPath}/registro" method="POST">
            <label for="nombre">Nombre Completo</label>
            <input type="text" id="nombre" name="nombre" placeholder="Ej: Carlos Mendoza" required>

            <label for="alias">Alias Único de usuario</label>
            <input type="text" id="alias" name="alias" placeholder="Ej: @carlosm" required>

            <label for="clave">Clave de 6 dígitos</label>
            <input type="password" id="clave" name="clave" placeholder="••••••" maxlength="6" required>

            <button type="submit">Crear Cuenta</button>
        </form>

        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <a href="login.jsp" class="login-link">¿Ya tienes cuenta? Inicia Sesión</a>
    </div>
</body>
</html>
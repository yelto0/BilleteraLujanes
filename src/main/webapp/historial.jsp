<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lujanes.model.Transaccion"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Historial de Lujanes</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; padding-top: 40px; margin: 0; }
        .card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.15); width: 400px; }
        h2 { color: #512da8; margin-top: 0; text-align: center; }
        .item { border-bottom: 1px solid #eee; padding: 12px 0; display: flex; justify-content: space-between; align-items: center; }
        .monto { font-weight: bold; color: #333; }
        .fecha { font-size: 11px; color: #888; }
        .btn { display: block; text-align: center; margin-top: 20px; padding: 10px; background-color: #7b1fa2; color: white; text-decoration: none; border-radius: 6px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Movimientos en Lujanes</h2>

        <% 
            List<Transaccion> historial = (List<Transaccion>) request.getAttribute("historial");
            if (historial != null && !historial.isEmpty()) {
                for (Transaccion t : historial) {
        %>
            <div class="item">
                <div>
                    <div><strong>De:</strong> <%= t.getEmisorNombre() %></div>
                    <div><strong>Para:</strong> <%= t.getReceptorNombre() %></div>
                    <div class="fecha"><%= t.getFecha() %></div>
                </div>
                <div class="monto">LJ/ <%= t.getMontoLujanes() %></div>
            </div>
        <% 
                }
            } else {
        %>
            <p style="text-align:center; color:#777;">No hay movimientos registrados.</p>
        <% } %>

        <a href="index.jsp" class="btn">Volver a transferir</a>
    </div>
</body>
</html>
package com.lujanes.controller;

import com.lujanes.dao.BilleteraDAO;
import com.lujanes.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/transferir")
public class TransferenciaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuarioEmisor = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioEmisor == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String aliasReceptor = request.getParameter("telefonoReceptor"); 
        double monto = Double.parseDouble(request.getParameter("monto"));

        BilleteraDAO dao = new BilleteraDAO();
        try {
            boolean exito = dao.transferirLujanes(usuarioEmisor.getId(), aliasReceptor, monto);

            if (exito) {
                // Actualizar saldo de la sesión local
                usuarioEmisor.setSaldoLujanes(usuarioEmisor.getSaldoLujanes() - monto);

                // Atributos para construir el voucher personalizado
                request.setAttribute("monto", String.format("%.2f", monto));
                request.setAttribute("receptor", aliasReceptor);
                request.setAttribute("celular", aliasReceptor);
                request.setAttribute("numOperacion", String.format("%08d", (int)(Math.random() * 100000000)));
                request.setAttribute("codigoSeguridad", String.format("%03d", (int)(Math.random() * 1000)));

                // Redirigir hacia la pantalla de comprobante
                request.getRequestDispatcher("voucher.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Alias no encontrado o saldo insuficiente.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al realizar el Lujaneo.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
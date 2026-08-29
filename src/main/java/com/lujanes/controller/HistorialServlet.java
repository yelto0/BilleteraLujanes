package com.lujanes.controller;

import com.lujanes.dao.BilleteraDAO;
import com.lujanes.model.Transaccion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/historial")
public class HistorialServlet extends HttpServlet {

    private BilleteraDAO billeteraDAO = new BilleteraDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int usuarioId = 1; // ID de prueba (Carlos)

        try {
            List<Transaccion> historial = billeteraDAO.obtenerHistorial(usuarioId);
            request.setAttribute("historial", historial);
            request.getRequestDispatcher("historial.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }
}
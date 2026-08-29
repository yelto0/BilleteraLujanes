package com.lujanes.controller;

import com.lujanes.dao.BilleteraDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        String alias = request.getParameter("alias");
        String clave = request.getParameter("clave");

        BilleteraDAO dao = new BilleteraDAO();
        
        try {
            boolean registrado = dao.registrarUsuario(nombre, alias, clave, 1000.0);

            if (registrado) {
                response.sendRedirect("login.jsp?registro=exito");
            } else {
                request.setAttribute("error", "El alias ya está en uso. Elige otro por favor.");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error al procesar el registro.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}
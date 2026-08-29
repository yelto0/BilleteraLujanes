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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String alias = request.getParameter("alias");
        String clave = request.getParameter("clave");

        BilleteraDAO dao = new BilleteraDAO();
        try {
            Usuario usuario = dao.autenticar(alias, clave);

            if (usuario != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", usuario);
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("error", "Alias o clave incorrecta.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error interno en la base de datos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
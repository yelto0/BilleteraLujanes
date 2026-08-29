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
import java.io.PrintWriter;

@WebServlet("/checkNotificacion")
public class NotificacionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");

        PrintWriter out = response.getWriter();

        if (usuario == null) {
            out.print("{\"actualizado\": false}");
            return;
        }

        BilleteraDAO dao = new BilleteraDAO();
        try {
            Usuario usuarioActualizado = dao.autenticar(usuario.getAlias(), usuario.getClave());
            if (usuarioActualizado != null) {
                double saldoAntiguo = usuario.getSaldoLujanes();
                double saldoNuevo = usuarioActualizado.getSaldoLujanes();

                // Verificar si recibió Lujanes (el saldo aumentó)
                if (saldoNuevo > saldoAntiguo) {
                    double diferencia = saldoNuevo - saldoAntiguo;
                    
                    // Actualizar el objeto de sesión
                    usuario.setSaldoLujanes(saldoNuevo);
                    session.setAttribute("usuarioLogueado", usuario);

                    out.print("{\"actualizado\": true, \"monto\": " + diferencia + ", \"nuevoSaldo\": " + saldoNuevo + "}");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        out.print("{\"actualizado\": false}");
    }
}
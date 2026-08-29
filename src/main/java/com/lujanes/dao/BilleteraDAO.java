package com.lujanes.dao;

import com.lujanes.datos.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class BilleteraDAO {

    public boolean registrarUsuario(String nombre, String alias, String clave, double saldoInicial) throws SQLException {
        // Verifica si el alias ya existe antes de registrar
        String sqlVerificarAlias = "SELECT id FROM usuarios WHERE alias = ?";
        String sqlUsuario = "INSERT INTO usuarios (nombre, alias, clave) VALUES (?, ?, ?)";
        String sqlBilletera = "INSERT INTO billeteras (usuario_id, saldo_lujanes) VALUES (?, ?)";

        Connection conn = null;

        try {
            conn = Conexion.getConexion();
            conn.setAutoCommit(false);

            // 1. Validar unicidad del alias
            try (PreparedStatement psVerif = conn.prepareStatement(sqlVerificarAlias)) {
                psVerif.setString(1, alias.trim().toLowerCase());
                try (ResultSet rs = psVerif.executeQuery()) {
                    if (rs.next()) {
                        conn.rollback();
                        return false; // Alias duplicado
                    }
                }
            }

            // 2. Insertar nuevo usuario con alias
            int nuevoUsuarioId = -1;
            try (PreparedStatement psUser = conn.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, nombre);
                psUser.setString(2, alias.trim().toLowerCase());
                psUser.setString(3, clave);

                int filas = psUser.executeUpdate();
                if (filas == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet rs = psUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        nuevoUsuarioId = rs.getInt(1);
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 3. Crear billetera inicial
            try (PreparedStatement psBill = conn.prepareStatement(sqlBilletera)) {
                psBill.setInt(1, nuevoUsuarioId);
                psBill.setDouble(2, saldoInicial);
                psBill.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public boolean transferirLujanes(int emisorId, String aliasReceptor, double monto) throws SQLException {
        String sqlBuscarReceptor = "SELECT usuario_id FROM billeteras b INNER JOIN usuarios u ON b.usuario_id = u.id WHERE LOWER(u.alias) = ?";
        String sqlVerificarSaldo = "SELECT saldo_lujanes FROM billeteras WHERE usuario_id = ?";
        String sqlDescontar = "UPDATE billeteras SET saldo_lujanes = saldo_lujanes - ? WHERE usuario_id = ?";
        String sqlAcreditar = "UPDATE billeteras SET saldo_lujanes = saldo_lujanes + ? WHERE usuario_id = ?";
        String sqlRegistrar = "INSERT INTO transacciones (emisor_id, receptor_id, monto_lujanes) VALUES (?, ?, ?)";

        Connection conn = null;

        try {
            conn = Conexion.getConexion();
            conn.setAutoCommit(false);

            int receptorId = -1;
            try (PreparedStatement ps = conn.prepareStatement(sqlBuscarReceptor)) {
                ps.setString(1, aliasReceptor.trim().toLowerCase());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        receptorId = rs.getInt("usuario_id");
                    } else {
                        conn.rollback();
                        return false; // Alias no existe
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlVerificarSaldo)) {
                ps.setInt(1, emisorId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        double saldoActual = rs.getDouble("saldo_lujanes");
                        if (saldoActual < monto) {
                            conn.rollback();
                            return false;
                        }
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlDescontar)) {
                ps.setDouble(1, monto);
                ps.setInt(2, emisorId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlAcreditar)) {
                ps.setDouble(1, monto);
                ps.setInt(2, receptorId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlRegistrar)) {
                ps.setInt(1, emisorId);
                ps.setInt(2, receptorId);
                ps.setDouble(3, monto);
                ps.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public com.lujanes.model.Usuario autenticar(String alias, String clave) throws SQLException {
        String sql = "SELECT u.id, u.nombre, u.alias, u.clave, b.saldo_lujanes " +
                     "FROM usuarios u " +
                     "INNER JOIN billeteras b ON u.id = b.usuario_id " +
                     "WHERE LOWER(u.alias) = ? AND u.clave = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, alias.trim().toLowerCase());
            ps.setString(2, clave);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new com.lujanes.model.Usuario(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getString("alias"),
                        rs.getString("clave"),
                        rs.getDouble("saldo_lujanes")
                    );
                }
            }
        }
        return null;
    }

    public java.util.List<com.lujanes.model.Transaccion> obtenerHistorial(int usuarioId) throws SQLException {
        java.util.List<com.lujanes.model.Transaccion> lista = new java.util.ArrayList<>();
        String sql = "SELECT t.id, u1.nombre AS emisor, u2.nombre AS receptor, t.monto_lujanes, t.fecha " +
                     "FROM transacciones t " +
                     "INNER JOIN usuarios u1 ON t.emisor_id = u1.id " +
                     "INNER JOIN usuarios u2 ON t.receptor_id = u2.id " +
                     "WHERE t.emisor_id = ? OR t.receptor_id = ? " +
                     "ORDER BY t.fecha DESC";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new com.lujanes.model.Transaccion(
                        rs.getInt("id"),
                        rs.getString("emisor"),
                        rs.getString("receptor"),
                        rs.getDouble("monto_lujanes"),
                        rs.getTimestamp("fecha")
                    ));
                }
            }
        }
        return lista;
    }
}
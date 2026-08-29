package com.lujanes.datos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL = "jdbc:mysql://mysql.railway.internal:3306/railway?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "sYUEEsyjFbeHojriKqZtVhhGZtezzhH";  

    public static Connection getConexion() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Error: Driver JDBC de MySQL no encontrado.", e);
        }
    }
}
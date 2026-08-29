package com.lujanes.model;

public class Usuario {
    private int id;
    private String nombre;
    private String alias;
    private String clave;
    private double saldoLujanes;

    public Usuario() {}

    public Usuario(int id, String nombre, String alias, String clave, double saldoLujanes) {
        this.id = id;
        this.nombre = nombre;
        this.alias = alias;
        this.clave = clave;
        this.saldoLujanes = saldoLujanes;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getAlias() { return alias; }
    public void setAlias(String alias) { this.alias = alias; }

    public String getClave() { return clave; }
    public void setClave(String clave) { this.clave = clave; }

    public double getSaldoLujanes() { return saldoLujanes; }
    public void setSaldoLujanes(double saldoLujanes) { this.saldoLujanes = saldoLujanes; }
}
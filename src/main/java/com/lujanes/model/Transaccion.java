package com.lujanes.model;

import java.sql.Timestamp;

public class Transaccion {
    private int id;
    private String emisorNombre;
    private String receptorNombre;
    private double montoLujanes;
    private Timestamp fecha;

    public Transaccion(int id, String emisorNombre, String receptorNombre, double montoLujanes, Timestamp fecha) {
        this.id = id;
        this.emisorNombre = emisorNombre;
        this.receptorNombre = receptorNombre;
        this.montoLujanes = montoLujanes;
        this.fecha = fecha;
    }

    public int getId() { return id; }
    public String getEmisorNombre() { return emisorNombre; }
    public String getReceptorNombre() { return receptorNombre; }
    public double getMontoLujanes() { return montoLujanes; }
    public Timestamp getFecha() { return fecha; }
}
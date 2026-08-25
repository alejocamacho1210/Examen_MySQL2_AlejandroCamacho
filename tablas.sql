-- =====================================================================
-- Sistema de Reservas de Salones de Eventos - Eventos Premier S.A.S.
-- Script 01: Creación de base de datos y tablas
-- Autor: Alejandro Camacho
-- Motor: MySQL 8.0.46
-- =====================================================================

DROP DATABASE IF EXISTS reservas_salones_eventos;
CREATE DATABASE reservas_salones_eventos
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_spanish_ci;

USE reservas_salones_eventos;

-- ---------------------------------------------------------------------
-- Tabla: salones
-- ---------------------------------------------------------------------
CREATE TABLE salones (
    id_salon        INT AUTO_INCREMENT PRIMARY KEY,
    nombre_salon    VARCHAR(100)   NOT NULL,
    capacidad       INT            NOT NULL,
    precio_hora     DECIMAL(10,2)  NOT NULL,
    estado          ENUM('Disponible', 'Ocupado', 'En mantenimiento') NOT NULL DEFAULT 'Disponible',
    encargado       VARCHAR(100)   NOT NULL,
    CHECK (capacidad > 0),
    CHECK (precio_hora > 0)
);

-- ---------------------------------------------------------------------
-- Tabla: clientes
-- ---------------------------------------------------------------------
CREATE TABLE clientes (
    id_cliente      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150)  NOT NULL,
    identificacion  VARCHAR(30)   NOT NULL UNIQUE,
    telefono        VARCHAR(20)   NOT NULL,
    correo          VARCHAR(120)  NOT NULL UNIQUE,
    tipo_cliente    ENUM('Individual', 'Corporativo') NOT NULL DEFAULT 'Individual'
);

-- ---------------------------------------------------------------------
-- Tabla: reservas
-- ---------------------------------------------------------------------
CREATE TABLE reservas (
    id_reserva      INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT           NOT NULL,
    id_salon        INT           NOT NULL,
    fecha_inicio    DATETIME      NOT NULL,
    fecha_fin       DATETIME      NOT NULL,
    total_horas     DECIMAL(6,2)  NOT NULL DEFAULT 0,
    valor_total     DECIMAL(12,2) NOT NULL DEFAULT 0,
    estado_reserva  ENUM('Activa', 'Cancelada') NOT NULL DEFAULT 'Activa',
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_reserva_salon FOREIGN KEY (id_salon) REFERENCES salones(id_salon)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (fecha_fin > fecha_inicio)
);

-- ---------------------------------------------------------------------
-- Tabla: pagos
-- ---------------------------------------------------------------------
CREATE TABLE pagos (
    id_pago         INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva      INT           NOT NULL,
    fecha_pago      DATE          NOT NULL,
    monto           DECIMAL(12,2) NOT NULL,
    metodo_pago     ENUM('Efectivo', 'Tarjeta', 'Transferencia') NOT NULL,
    CONSTRAINT fk_pago_reserva FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (monto > 0)
);

-- ---------------------------------------------------------------------
-- Tabla: auditoria_precios (para el trigger de auditoría)
-- ---------------------------------------------------------------------
CREATE TABLE auditoria_precios (
    id_auditoria    INT AUTO_INCREMENT PRIMARY KEY,
    id_salon        INT           NOT NULL,
    usuario         VARCHAR(100)  NOT NULL,
    fecha_cambio    DATETIME      NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo    DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_auditoria_salon FOREIGN KEY (id_salon) REFERENCES salones(id_salon)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- Índices de apoyo para consultas frecuentes
-- ---------------------------------------------------------------------
CREATE INDEX idx_reservas_fechas ON reservas(fecha_inicio, fecha_fin);
CREATE INDEX idx_reservas_salon ON reservas(id_salon);
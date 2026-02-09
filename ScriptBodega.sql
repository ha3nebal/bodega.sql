-- Creación de la Base de Datos
CREATE DATABASE BodegaProducDelMar_DB;
USE BodegaProducDelMar_DB;

-- 1. Tabla de Categorías
CREATE TABLE Categorias (
    cat_id INT AUTO_INCREMENT PRIMARY KEY,
    cat_nom VARCHAR(50) NOT NULL
);

-- 2. Tabla de Productos
CREATE TABLE Productos (
    prod_id INT AUTO_INCREMENT PRIMARY KEY,
    prod_nom VARCHAR(50) NOT NULL,
    prod_pre DECIMAL(10,2) NOT NULL,
    prod_stk DECIMAL(10,2) DEFAULT 0,
    cat_id INT,
    CONSTRAINT fk_categoria FOREIGN KEY (cat_id) REFERENCES Categorias(cat_id)
);

-- 3. Tabla de Clientes
CREATE TABLE Clientes (
    cli_id INT AUTO_INCREMENT PRIMARY KEY,
    cli_rut VARCHAR(12) UNIQUE NOT NULL,
    cli_nom VARCHAR(100) NOT NULL,
    cli_tel VARCHAR(15)
);

-- 4. Tabla de Ventas (Cabecera)
CREATE TABLE Ventas (
    ven_id INT AUTO_INCREMENT PRIMARY KEY,
    ven_fec TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cli_id INT,
    ven_tot DECIMAL(10,2),
    CONSTRAINT fk_cliente FOREIGN KEY (cli_id) REFERENCES Clientes(cli_id)
);

-- 5. Detalle de Venta
CREATE TABLE Detalle_Ventas (
    det_id INT AUTO_INCREMENT PRIMARY KEY,
    ven_id INT,
    prod_id INT,
    det_cant DECIMAL(10,2),
    det_subt DECIMAL(10,2),
    CONSTRAINT fk_venta FOREIGN KEY (ven_id) REFERENCES Ventas(ven_id),
    CONSTRAINT fk_producto FOREIGN KEY (prod_id) REFERENCES Productos(prod_id)
);

-- 6. Creación de la tabla de Proveedores
CREATE TABLE Proveedores (
    prov_id INT AUTO_INCREMENT PRIMARY KEY,
    prov_rut VARCHAR(12) NOT NULL UNIQUE,
    prov_nom VARCHAR(100) NOT NULL,
    prov_contacto VARCHAR(50),
    prov_tel VARCHAR(15),
    prov_mail VARCHAR(100),
    prov_zona VARCHAR(50), -- Importante para trazabilidad de mariscos
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Creación de la tabla de Compras (Entrada de Inventario)
-- Relaciona los productos con sus proveedores
CREATE TABLE Compras (
    com_id INT AUTO_INCREMENT PRIMARY KEY,
    prov_id INT,
    com_fec DATE NOT NULL,
    com_total DECIMAL(12,2),
    com_obs TEXT, -- Para anotar estado de frescura, temperatura, etc.
    CONSTRAINT fk_proveedor_compra FOREIGN KEY (prov_id) REFERENCES Proveedores(prov_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Detalle de la compra (qué pescados entraron y a qué costo)
CREATE TABLE Detalle_Compras (
    detc_id INT AUTO_INCREMENT PRIMARY KEY,
    com_id INT,
    prod_id INT,
    detc_cant DECIMAL(10,2), -- Cantidad en KG
    detc_costo_unit DECIMAL(10,2), -- Costo de compra
    CONSTRAINT fk_compra_maestra FOREIGN KEY (com_id) REFERENCES Compras(com_id),
    CONSTRAINT fk_producto_compra FOREIGN KEY (prod_id) REFERENCES Productos(prod_id)
) ENGINE=InnoDB;

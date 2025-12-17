-- Establecer las relaciones entre tablas

-- Definir claves primarias
ALTER TABLE entregas
ADD CONSTRAINT pk_entregas
PRIMARY KEY ("COD_ENTREGA");

ALTER TABLE productos
ADD CONSTRAINT pk_productos 
PRIMARY KEY ("COD_PRODUCTO");

ALTER TABLE sucursales
ADD CONSTRAINT pk_sucursales
PRIMARY KEY ("COD_SUCURSAL");

ALTER TABLE transportistas
ADD CONSTRAINT pk_transportistas 
PRIMARY KEY ("COD_PLACA");

ALTER TABLE empresa_transporte
ADD CONSTRAINT pk_empresa_transporte
PRIMARY KEY ("COD_EMPRESATRANSPORTE");

ALTER TABLE ciudad_destino
ADD CONSTRAINT pk_ciudad_destino
PRIMARY KEY ("COD_DESCARGUE");

-- Conectar tabla productos con tabla entregas
ALTER TABLE entregas
ADD CONSTRAINT fk_entregas_productos
FOREIGN KEY ("COD_PRODUCTO")
REFERENCES productos("COD_PRODUCTO");

-- Conectar tabla sucursales con tabla entregas
ALTER TABLE entregas
ADD CONSTRAINT fk_entregas_sucursales
FOREIGN KEY ("COD_SUCURSAL")
REFERENCES sucursales("COD_SUCURSAL");

-- Conectar tabla transportistas con tabla entregas
ALTER TABLE entregas
ADD CONSTRAINT fk_entregas_transportistas
FOREIGN KEY ("COD_PLACA")
REFERENCES transportistas("COD_PLACA");

-- Conectar tabla enmpresa transporte con tabla entregas
ALTER TABLE entregas
ADD CONSTRAINT fk_entregas_empresa_transporte
FOREIGN KEY ("COD_EMPRESATRANSPORTE")
REFERENCES empresa_transporte("COD_EMPRESATRANSPORTE");

-- Conectar tabla ciudad destino con tabla entregas
ALTER TABLE entregas
ADD CONSTRAINT fk_entregas_ciudad_destino
FOREIGN KEY ("COD_DESCARGUE")
REFERENCES ciudad_destino("COD_DESCARGUE");
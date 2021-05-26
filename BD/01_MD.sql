DROP DATABASE IF EXISTS CrianzaCuy;   

CREATE DATABASE IF NOT EXISTS CrianzaCuy;   

USE CrianzaCuy; 

DROP TABLE IF EXISTS Usuario; 

CREATE TABLE IF NOT EXISTS Usuario 
( 
	id         SMALLINT  AUTO_INCREMENT, 
	dni        CHAR(8) UNIQUE NOT NULL, 
	password   VARCHAR(60) NOT NULL, 
	nombres    VARCHAR(50) NOT NULL, 
	apellidos  VARCHAR(50) NOT NULL, 
	rol        ENUM('Admin', 'SuperUser') DEFAULT 'SuperUser',
	PRIMARY KEY(id, dni)
); 
  
  
DROP TABLE IF EXISTS TipoFase; 
  
CREATE TABLE IF NOT EXISTS TipoFase
( 
	id         	SMALLINT PRIMARY KEY AUTO_INCREMENT, 
	Nombre   	VARCHAR(60) NOT NULL,
	Peso       	VARCHAR(25) NOT NULL,
	Duracion   	SMALLINT
); 
  
DROP TABLE IF EXISTS TipoCosteo; 
  
CREATE TABLE IF NOT EXISTS TipoCosteo
( 
	id         	SMALLINT PRIMARY KEY AUTO_INCREMENT, 
	Tipo 		CHAR(1) NOT NULL,
	idHijo		SMALLINT NOT NULL, 
	Nombre		VARCHAR(50),
	Medida     	VARCHAR(25)
); 

DROP TABLE IF EXISTS PuenteCosteoFase; 

CREATE TABLE IF NOT EXISTS PuenteCosteoFase
(
	id 			SMALLINT PRIMARY KEY AUTO_INCREMENT,
	idCosteo 	SMALLINT NOT NULL,
    idFase		SMALLINT NOT NULL,
    CONSTRAINT FOREIGN KEY FK_TipoCosteo_PuenteCosteoFase (idCosteo) REFERENCES TipoCosteo (id),
    CONSTRAINT FOREIGN KEY FK_TipoFase_PuenteCosteoFase (idFase) REFERENCES TipoFase (id)
);
  
DROP TABLE IF EXISTS DetalleCosteo; 
  
CREATE TABLE IF NOT EXISTS DetalleCosteo
( 
	 id         		SMALLINT PRIMARY KEY AUTO_INCREMENT, 
     dni      			CHAR(8) NOT NULL, 
     idTipoFase			SMALLINT NOT NULL,
     idTipoCosteo		SMALLINT NOT NULL,
     Cantidad			DECIMAL(9,2),
     CostoUnitario		DECIMAL(9,2),
     CostoTotal			DECIMAL(9,2),
     CostoMensual		DECIMAL(9,2),
     FechaRegistro		DATE,
     CONSTRAINT FOREIGN KEY FK_Usuario_DetalleCosteo (dni) REFERENCES Usuario (dni),
     CONSTRAINT FOREIGN KEY FK_PuenteCosteo_DetalleCosteo (idTipoCosteo) REFERENCES PuenteCosteoFase (idCosteo),
     CONSTRAINT FOREIGN KEY FK_PuenteFase_DetalleCosteo (idTipoFase) REFERENCES PuenteCosteoFase (idFase)
); 

DROP TABLE IF EXISTS tmpJson; 

CREATE TABLE IF NOT EXISTS tmpJson (
	id SMALLINT, 
    dni CHAR(8), 
    idCosteo SMALLINT, 
    idFase SMALLINT, 
	cantidad DECIMAL(9,2), 
    costoUnitario DECIMAL(9,2) DEFAULT NULL, 
    costoTotal DECIMAL(9,2) DEFAULT NULL,
	costoMensual DECIMAL(9,2) DEFAULT NULL, 
    fecha DATE
);

DROP TABLE IF EXISTS DetalleConsolidado; 

CREATE TABLE IF NOT EXISTS DetalleConsolidado (
    dni CHAR(8), 
	ValorVenta1 DECIMAL(9,2), 
    ValorVenta2 DECIMAL(9,2), 
    FechaRegistro DATE
);
  
  
  
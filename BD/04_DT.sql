/*
	04_DT - INSERCIÓN DE DATOS
*/
##INSERT INTO Usuario VALUES (id, '47238670', '$2a$08$i0XKZ.MvN89VFIp1FZx33.ePn3YUTr7WZkXzKHufCSYDFytKZijXW', 'Luis Eduardo', 'Pizarro Canto', 'SuperUser');

/* Insertar Tipo Fase */

INSERT INTO TipoFase VALUES (id, 'REPRODUCCIÓN', '750gr. a 950gr.', 90);
INSERT INTO TipoFase VALUES	(id, 'LACTANCIA', 'hasta 200gr.', 15);
INSERT INTO TipoFase VALUES	(id, 'RECRIA', '350gr.', 15);
INSERT INTO TipoFase VALUES	(id, 'ENGORDE', '750gr. a 1000gr.', 60);
INSERT INTO TipoFase VALUES	(id, 'SIN REGISTRO', '', 0);
/* Insertar Costeo Variable */

INSERT INTO TipoCosteo VALUES	(id, 'V', 0, 'COSTOS VARIABLES', '');
SET @Id = LAST_INSERT_ID();
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'EMPADRE (Macho)', 'Und.');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'EMPADRE (Hembra)', 'Und.');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'No. de partos por hembra', 'Veces');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'No. de gazapos por hembra', 'Und.');
INSERT INTO TipoCosteo VALUES	(id, 'V', 0, 'ALIMENTACIÓN', '');
SET @Id = LAST_INSERT_ID();
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'Forraje verde / Desidratado', 'Kilos');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'Forraje verde / Desidratado', 'Paquete (11Kls.)');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'Forraje verde (Consumo Per-Cápita)', 'diario (gr.)');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'Concentrados/suplemento', 'Kilos');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'Concentrados/suplemento', 'Sacos (49Kls.)');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'Concentrados/suplemento (Consumo Per-Cápita)', 'diario (gr.)');
INSERT INTO TipoCosteo VALUES	(id, 'V', 0, 'VACUNAS', '');
SET @Id = LAST_INSERT_ID();
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'Antiparasitarios, etc', 'Unid.');
INSERT INTO TipoCosteo VALUES	(id, 'V', @Id, 'Antiparasitarios, etc', 'Veces');

/* Insertar Costeo Fijo */

INSERT INTO TipoCosteo VALUES	(id, 'F', 0, 'Mano de Obra Directa', '');
SET @Id = LAST_INSERT_ID();
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Personal de atención', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Personal de corte', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Personal de Limpieza', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Ss. Beneficio de Cuyes', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', 0, 'Materia Prima Indirecta', '');
SET @Id = LAST_INSERT_ID();
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Insumos de limpieza y desinfección', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Envasado al vacío', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', 0, 'Otros Costos Indirectos', '');
SET @Id = LAST_INSERT_ID();
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Depreciación de Infraestructura', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Depreciación equipos', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Alquiler de infraestructura', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Imp. Predial y Arbitrios Infraestructura', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', 0, 'Gastos Administrativos', '');
SET @Id = LAST_INSERT_ID();
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Administrador', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Contador', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Ss. De Luz', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Ss. De Agua', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', 0, 'Gastos de Ventas', '');
SET @Id = LAST_INSERT_ID();
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Personal de Ventas', '');
INSERT INTO TipoCosteo VALUES	(id, 'F', @Id, 'Transporte de forraje y otros', '');

/*    Insertamos Puente Costeo Fase   */

INSERT INTO PuenteCosteoFase (id, idCosteo, idFase)
SELECT null, id AS idTipoCosteo, 1 FROM TipoCosteo WHERE Tipo = 'V'
UNION ALL
SELECT null, id AS idTipoCosteo, 2 FROM TipoCosteo WHERE Tipo = 'V'
UNION ALL
SELECT null, id AS idTipoCosteo, 3 FROM TipoCosteo WHERE Tipo = 'V'
UNION ALL
SELECT null, id AS idTipoCosteo, 4 FROM TipoCosteo WHERE Tipo = 'V'
UNION ALL
SELECT null, id AS idTipoCosteo, 5 FROM TipoCosteo WHERE Tipo = 'F';

/*
INSERT INTO DetalleCosteo (id, dni, idTipoFase, idTipoCosteo, Cantidad, 
						   CostoUnitario, CostoTotal, CostoMensual, FechaRegistro)
				   VALUES (id, '47238670', 1, 2, 1, 35.00, 1.17, 0.00, CAST(NOW() AS DATE))
*/  

	

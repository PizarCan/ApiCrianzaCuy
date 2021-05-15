USE CrianzaCuy;

DROP PROCEDURE IF EXISTS BuscarUsuarioDni_SP; 

DELIMITER //
CREATE PROCEDURE BuscarUsuarioDni_SP(
  IN x_cdni 		CHAR(8)
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Devuelve Usuario por DNI
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL BuscarUsuarioDni_SP('47238670');
-------------------------------------------------------------------------------*/
) BEGIN
	SELECT id, dni, password, CONCAT_WS(' ', nombres, apellidos) AS nombreUsuario, rol
    FROM Usuario
    WHERE dni = x_cdni; 
  END//
DELIMITER ;

/********************************************************/

DROP PROCEDURE IF EXISTS ValidarLogin_SP; 

DELIMITER //
CREATE PROCEDURE ValidarLogin_SP(
  IN x_cdni 		CHAR(8),
  IN x_cpassword VARCHAR(60)
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Valida Inicio de Sesión 
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL ValidarLogin_SP('47238670', '$2a$08$i0XKZ.MvN89VFIp1FZx33.ePn3YUTr7WZkXzKHufCSYDFytKZijXW');
-------------------------------------------------------------------------------*/
) BEGIN
	SELECT id, dni, CONCAT_WS(' ', nombres, apellidos) AS nombreUsuario, rol
    FROM Usuario
    WHERE dni = x_cdni 
		AND password = x_cpassword;
  END//
DELIMITER ;

/********************************************************/
DROP PROCEDURE IF EXISTS IngresarUsuario_SP; 

DELIMITER //
CREATE PROCEDURE IngresarUsuario_SP(
  IN x_cdni 		CHAR(8),
  IN x_cpassword 	VARCHAR(60),
  IN x_cnombres 	VARCHAR(50),
  IN x_capellidos  	VARCHAR(50),
  IN x_crol			ENUM('Admin', 'SuperUser')
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Creación Nuevo Usuario 
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL IngresarUsuario_SP('45468031', '123456', 'Flor', 'Taipe Aparco', 'SuperUser');
-------------------------------------------------------------------------------*/  
) BEGIN
	INSERT INTO Usuario (id, dni, password, nombres, apellidos, rol)
				 VALUES (null, x_cdni, x_cpassword, x_cnombres, x_capellidos, x_crol); 
  END//
DELIMITER ;

/********************************************************/
DROP PROCEDURE IF EXISTS InsertarDetalleCosteo_SP; 

DELIMITER //
CREATE PROCEDURE InsertarDetalleCosteo_SP(
	IN x_cDni CHAR(8),
    IN x_jDetalleCosteo JSON
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Insercción Detalle Costeo
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL InsertarDetalleCosteo_SP('47238670','[{"item_id":1,"model_number":"MFJA53","quantity":4},{"item_id":2,"model_number":"HSRHJN5","quantity":null},{"item_id":3,"model_number":"FAFAF1","quantity":345}]'); 
-------------------------------------------------------------------------------*/    
)
BEGIN
	DECLARE vJsonEsValido INT;
    DECLARE vItems INT;
    
	SET vJsonEsValido = JSON_VALID(x_jDetalleCosteo);
    
    IF vJsonEsValido = 0 THEN 
        SELECT "JSON suministrado no es válido";
    ELSE 
        # Tiene 1 Estructura
        SET vItems = JSON_LENGTH(x_jDetalleCosteo);

		# Contiene al menos un elemento
        IF vItems > 0 THEN 
			/*
            INSERT INTO DetalleCosteo (id, dni, idTipoFase, idTipoCosteo, Cantidad, 
									   CostoUnitario, CostoTotal, CostoMensual, FechaRegistro)
            */

			CREATE TEMPORARY TABLE tmpJson (
				ID INT,
                MODEL VARCHAR(100),
                CANTIDAD VARCHAR(100)
            );
		
			INSERT INTO tmpJson VALUES (1, 'LENOVO', '120');
			
            /*
			SELECT A.item_id,
				   A.model_number,
				   CAST(CASE TRUE 
								WHEN A.quantity = 'NULL' THEN NULL 
								ELSE A.quantity 
						END AS SIGNED) AS quantity
			FROM JSON_TABLE
			(
				x_jDetalleCosteo
				, "$[*]"
				COLUMNS
				(
					item_id INT PATH "$.item_id",
					model_number VARCHAR(100) PATH "$.model_number",
					quantity VARCHAR(100) PATH "$.quantity"
				)
			) A;*/
        END IF;
	END IF;
END//
DELIMITER ;

/********************************************************/
DROP PROCEDURE IF EXISTS MostrarDetalleCosteo_SP; 

DELIMITER //
CREATE PROCEDURE MostrarDetalleCosteo_SP(
	IN x_cDni CHAR(8),
    IN x_cTipoFase SMALLINT
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Mostrar Detalle de Costeo
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL MostrarDetalleCosteo_SP('47238670', 1);
-------------------------------------------------------------------------------*/        
)
BEGIN
	# Si no existe registro devuelve en blanco
	SELECT	A.idCosteo AS id, B.Tipo, B.idHijo, 
			B.Nombre AS ElementoCosto, B.Medida, 
			C.id AS idTipoFase, 
            C.Nombre AS NombreFase,
            C.Peso,
            C.Duracion,
			COALESCE(D.id, 0) AS idCosteo, 
			COALESCE(D.dni, x_cDni) AS dni, 
			COALESCE(D.Cantidad, 0) AS Cantidad, 
			COALESCE(D.CostoUnitario, 0.00) AS CostoUnitario,
			COALESCE(D.CostoTotal, 0.00) AS CostoTotal,
			COALESCE(D.FechaRegistro, CAST(NOW() AS DATE)) AS FechaRegistro
	FROM PuenteCosteoFase  A
		INNER JOIN TipoCosteo B
			ON A.idCosteo = B.id
				AND B.Tipo = 'V'
		INNER JOIN TipoFase C
			ON A.idFase = C.id
				AND A.idFase = x_cTipoFase
		LEFT JOIN DetalleCosteo D
			ON A.idCosteo = D.idTipoCosteo   
				AND A.idFase = D.idTipoFase
				AND D.dni = x_cDni;
END//
DELIMITER ;

/********************************************************/
DROP PROCEDURE IF EXISTS MostrarCostoFijo_SP; 

DELIMITER //
CREATE PROCEDURE MostrarCostoFijo_SP(
	IN x_cDni CHAR(8)
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Mostrar Detalle de Costeo
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL MostrarCostoFijo_SP('47238670');
-------------------------------------------------------------------------------*/        
)
BEGIN
	SELECT	A.id AS idCosteo, A.Tipo, A.idHijo, 
			A.Nombre AS ElementoCosto,
            COALESCE(C.id, 0) AS id, 
			COALESCE(C.dni, x_cDni) AS dni, 
			COALESCE(C.CostoMensual, 0.00) AS CostoMensual,
            IF(COALESCE(C.CostoMensual, 0.00) = 0, 0.00, C.CostoMensual/30.00) AS CostoDiario,
			COALESCE(C.FechaRegistro, CAST(NOW() AS DATE)) AS FechaRegistro
	FROM (SELECT id, Tipo, idHijo, Nombre
		  FROM TipoCosteo WHERE Tipo = 'F') A
		LEFT JOIN DetalleCosteo C
			ON A.id = C.idTipoCosteo   
				AND C.dni = x_cDni;
END//
DELIMITER ;

/********************************************************/
DROP PROCEDURE IF EXISTS InsertarActualizarCosto_SP; 

DELIMITER //
CREATE PROCEDURE InsertarActualizarCosto_SP(
	IN x_jData JSON
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Insertar / Actualizar Costos (Variables/Variables)
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL InsertarActualizarCosto_SP('[{"id":0,"dni":"47238670","idcosteo":4, "idfase": 1, "cantidad": 10, "costounitario": 12.15, "costototal": 35.42, "costomensual": 0.00}]');
-------------------------------------------------------------------------------*/        
)
BEGIN
	DECLARE vJsonEsValido INT;
    DECLARE vItems INT;
    
	SET vJsonEsValido = JSON_VALID(x_jData);
    
    IF vJsonEsValido = 0 THEN 
        SELECT "JSON suministrado no es válido";
    ELSE 
        # Tiene 1 Estructura
        SET vItems = JSON_LENGTH(x_jData);

		# Contiene al menos un elemento
        IF vItems > 0 THEN 
			
            DROP TABLE IF EXISTS tmpJson; 
            
			CREATE TEMPORARY TABLE IF NOT EXISTS tmpJson (
				id SMALLINT, dni CHAR(8), idCosteo SMALLINT, idFase SMALLINT, 
                cantidad SMALLINT, costoUnitario DECIMAL(9,6) DEFAULT NULL, costoTotal DECIMAL(9,6) DEFAULT NULL,
                costoMensual DECIMAL(9,6) DEFAULT NULL, fecha DATE
            );
		
			INSERT INTO tmpJson
			SELECT A.id,
				   A.dni,
                   A.idCosteo,
				   A.idFase,
                   A.cantidad,
				   A.costoUnitario,
                   A.costoTotal ,     
                   A.costoMensual,
                   CAST(NOW() AS DATE) AS fecha   
			FROM JSON_TABLE
			(
				x_jData
				, "$[*]"
				COLUMNS
				(
					id 				SMALLINT PATH "$.id",
					dni 			CHAR(8) PATH "$.dni",
                    idCosteo 		SMALLINT PATH "$.idcosteo",
                    idFase   		SMALLINT PATH "$.idfase",
                    cantidad 		SMALLINT PATH "$.cantidad",
                    costoUnitario 	DECIMAL(9,2) PATH "$.costounitario",
                    costoTotal 		DECIMAL(9,2) PATH "$.costototal",
                    costoMensual 	DECIMAL(9,2) PATH "$.costomensual"
				)
			) A;
		
            IF EXISTS (SELECT 1 
						   FROM tmpJson 
						   WHERE id = 0) THEN
                 
                SET @lnIdFase = (SELECT idFase FROM tmpJson);
                
                IF @lnIdFase = 1 THEN
					INSERT INTO DetalleCosteo (id, dni, idTipoFase, idTipoCosteo, Cantidad, 
										   CostoUnitario, CostoTotal, CostoMensual, FechaRegistro)
					SELECT null, dni, idFase, idCosteo = 7, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 10, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 14, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson;
                END IF;
                
                IF @lnIdFase = 2 THEN
					INSERT INTO DetalleCosteo (id, dni, idTipoFase, idTipoCosteo, Cantidad, 
										   CostoUnitario, CostoTotal, CostoMensual, FechaRegistro)
					SELECT null, dni, idFase, idCosteo = 2, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 7, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 14, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson;
                END IF;
                
                IF @lnIdFase = 3 THEN
					INSERT INTO DetalleCosteo (id, dni, idTipoFase, idTipoCosteo, Cantidad, 
										   CostoUnitario, CostoTotal, CostoMensual, FechaRegistro)
					SELECT null, dni, idFase, idCosteo = 3, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 7, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 8, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
                    UNION 
					SELECT null, dni, idFase, idCosteo = 10, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
                    UNION 
					SELECT null, dni, idFase, idCosteo = 11, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
                    UNION 
					SELECT null, dni, idFase, idCosteo = 12, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson;
                END IF;
                
                IF @lnIdFase = 4 THEN
					INSERT INTO DetalleCosteo (id, dni, idTipoFase, idTipoCosteo, Cantidad, 
										   CostoUnitario, CostoTotal, CostoMensual, FechaRegistro)
					SELECT null, dni, idFase, idCosteo = 3, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 7, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 8, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
                    UNION 
					SELECT null, dni, idFase, idCosteo = 10, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
                    UNION 
					SELECT null, dni, idFase, idCosteo = 11, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
                    UNION 
					SELECT null, dni, idFase, idCosteo = 12, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson
					UNION 
					SELECT null, dni, idFase, idCosteo = 14, cantidad = 0, 
						   costoUnitario = 0.00, costoTotal = 0.00, costoMensual = 0.00, fecha
					FROM tmpJson;
                END IF;
                 
				INSERT INTO DetalleCosteo (id, dni, idTipoFase, idTipoCosteo, Cantidad, 
										   CostoUnitario, CostoTotal, CostoMensual, FechaRegistro)
                SELECT null, dni, idFase, idCosteo, cantidad, 
					   costoUnitario, costoTotal, costoMensual, fecha
                FROM tmpJson;
             ELSE
				UPDATE DetalleCosteo A
                INNER JOIN tmpJson B
					ON A.id = B.id	
						AND A.dni = B.dni
                SET A.Cantidad = B.cantidad,
					A.CostoUnitario = B.costoUnitario,
                    A.CostoTotal = B.costoTotal,
                    A.CostoMensual = B.costoMensual;
             END IF;   
             
        END IF;
        
	END IF;
END//
DELIMITER ;

/********************************************************/

DROP PROCEDURE IF EXISTS CalcularCosteo_SP; 

DELIMITER //
CREATE PROCEDURE CalcularCosteo_SP(
  IN x_cdni 		CHAR(8)
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Valida Inicio de Sesión 
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL CalcularCosteo_SP('47238670');
-------------------------------------------------------------------------------*/
) BEGIN
	
    ## Actualización Costo Total - Fase Producción
    
    ## EMPADRE (Macho)
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 3
		INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 4
    SET A.CostoTotal = (A.Cantidad * A.CostoUnitario) / (B.Cantidad * C.Cantidad)
    WHERE A.dni = x_cdni
		AND idTipoCosteo = 2
        AND idTipoFase = 1;
    
    ## EMPADRE (Hembra)
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 4
    SET A.CostoTotal = (A.Cantidad * A.CostoUnitario) / (A.Cantidad * C.Cantidad)
    WHERE A.dni = x_cdni
		AND idTipoCosteo = 3
        AND idTipoFase = 1;
        
    ## Forraje verde / Desidratado    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 3
		INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 2
        INNER JOIN DetalleCosteo D
			ON A.dni = D.dni
				AND D.idTipoCosteo = 9   
    SET A.Cantidad = (D.Cantidad * (B.Cantidad + C.Cantidad) * duracion) / 1000
    WHERE A.dni = x_cdni
		AND idTipoCosteo = 7
        AND idTipoFase = 1;    
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 8
    SET A.CostoUnitario = B.Cantidad / 11
    WHERE A.dni = x_cdni
		AND idTipoCosteo = 7
        AND idTipoFase = 1;
		
    UPDATE DetalleCosteo 
    SET CostoTotal = Cantidad * CostoUnitario
    WHERE dni = x_cdni
		AND idTipoCosteo = 7
        AND idTipoFase = 1;    
    
    ## Concentrados/suplemento
	UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 3
		INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 2
        INNER JOIN DetalleCosteo D
			ON A.dni = D.dni
				AND D.idTipoCosteo = 12  
    SET A.Cantidad = (D.Cantidad * (B.Cantidad + C.Cantidad) * duracion) / 1000
    WHERE A.dni = x_cdni
		AND idTipoCosteo = 10
        AND idTipoFase = 1;    
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 11
    SET A.CostoUnitario = B.Cantidad / 49
    WHERE A.dni = x_cdni
		AND idTipoCosteo = 10
        AND idTipoFase = 1;
		
    UPDATE DetalleCosteo 
    SET CostoTotal = Cantidad * CostoUnitario * 3
    WHERE dni = x_cdni
		AND idTipoCosteo = 10
        AND idTipoFase = 1;   
    
    ## Antiparasitarios, etc
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 3       
    SET A.CostoTotal = B.Cantidad * C.Cantidad
    WHERE A.dni = x_cdni
		AND idTipoCosteo = 14
        AND idTipoFase = 1;
        
  END//
DELIMITER ;

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
-- CALL IngresarUsuario_SP('45468034', '$2a$08$i0XKZ.MvN89VFIp1FZx33.ePn3YUTr7WZkXzKHufCSYDFytKZijXW', 'Flor', 'Taipe Aparco', 'SuperUser');
-------------------------------------------------------------------------------*/  
) BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;  
        ROLLBACK;   
    END;
    
    SET @inserted_rows = 0;
    
    START TRANSACTION;

		INSERT INTO Usuario (id, dni, password, nombres, apellidos, rol)
					 VALUES (null, x_cdni, x_cpassword, x_cnombres, x_capellidos, x_crol); 
                 
		INSERT INTO DetalleCosteo (id, dni, idTipoFase, idTipoCosteo, Cantidad, 
							   CostoUnitario, CostoTotal, CostoMensual, FechaRegistro)
							   
		/********************************************************
		## Inserta Plantilla Costos
		*********************************************************/
		## Fase Reproducción
		SELECT null, x_cdni, 1, 7, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 1, 10, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 1, 14, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION
		## Fase Lactancia
		SELECT null, x_cdni, 2, 2, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 2, 7, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 2, 8, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION
		## Fase Recria
		SELECT null, x_cdni, 3, 3, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 3, 7, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 3, 8, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 3, 10, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 3, 11, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 3, 12, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION ALL
		## Fase Engorde
		SELECT null, x_cdni, 4, 3, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 4, 7, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 4, 8, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 4, 10, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 4, 11, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 4, 12, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE)
		UNION 
		SELECT null, x_cdni, 4, 14, 0, 0.00, 0.00, 0.00, CAST(NOW() AS DATE);
        
        SET @inserted_rows = ROW_COUNT() + @inserted_rows;
    COMMIT;
    SELECT @inserted_rows AS inserted_rows;
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
			CAST(COALESCE(D.CostoUnitario, 0.00) AS DECIMAL(9,2)) AS CostoUnitario,
			CAST(COALESCE(D.CostoTotal, 0.00) AS DECIMAL(9,2)) AS CostoTotal,
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
            COALESCE(C.CostoUnitario, 0.00) AS CostoDiario,
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
-- CALL InsertarActualizarCosto_SP('[{"id":0,"dni":"47238670","idcosteo":2, "idfase": 4, "cantidad": "18", "costounitario": 0.00, "costototal": 0.00, "costomensual": 0.00}]');
-------------------------------------------------------------------------------*/        
)
BEGIN
	DECLARE vJsonEsValido INT;
	DECLARE vItems INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;  
        ROLLBACK;   
    END;

	START TRANSACTION;
    
		SET vJsonEsValido = JSON_VALID(x_jData);
		
		IF vJsonEsValido = 0 THEN 
			SELECT "JSON suministrado no es válido";
		ELSE 
			# Tiene 1 Estructura
			SET vItems = JSON_LENGTH(x_jData);

			# Contiene al menos un elemento
			IF vItems > 0 THEN 
				
				TRUNCATE TABLE tmpJson; 
				
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
						cantidad 		DECIMAL(9,2) PATH "$.cantidad",
						costoUnitario 	DECIMAL(9,2) PATH "$.costounitario",
						costoTotal 		DECIMAL(9,2) PATH "$.costototal",
						costoMensual 	DECIMAL(9,2) PATH "$.costomensual"
					)
				) A;
			
				IF EXISTS (SELECT 1 
							   FROM tmpJson 
							   WHERE id = 0) THEN
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
						A.CostoMensual = B.costoMensual;
				 END IF;   
				
			END IF;
			
		END IF;
        
        SET @lcDni = (SELECT dni FROM tmpJson);
				
		CALL CalcularCosteo_SP(@lcDni);
        
    COMMIT;
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
                AND B.idTipoFase = 1
		INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 4
                AND C.idTipoFase = 1
    SET A.CostoTotal = (A.Cantidad * A.CostoUnitario) / (B.Cantidad * C.Cantidad)
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 2
        AND A.idTipoFase = 1;
    
    ## EMPADRE (Hembra)
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 4
                AND B.idTipoFase = 1
    SET A.CostoTotal = (A.Cantidad * A.CostoUnitario) / (A.Cantidad * B.Cantidad)
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 3
        AND A.idTipoFase = 1;
        
    ## Forraje verde / Desidratado    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 3
                AND B.idTipoFase = 1
		INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 2
                AND C.idTipoFase = 1
        INNER JOIN DetalleCosteo D
			ON A.dni = D.dni
				AND D.idTipoCosteo = 9  
                AND D.idTipoFase = 1
    SET A.Cantidad = (D.Cantidad * (B.Cantidad + C.Cantidad) * 90) / 1000
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 7
        AND A.idTipoFase = 1;    
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 8
                AND B.idTipoFase = 1
    SET A.CostoUnitario = B.Cantidad / 11
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 7
        AND A.idTipoFase = 1;
		
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
                AND B.idTipoFase = 1
		INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 2
                AND C.idTipoFase = 1
        INNER JOIN DetalleCosteo D
			ON A.dni = D.dni
				AND D.idTipoCosteo = 12  
                AND D.idTipoFase = 1
    SET A.Cantidad = (D.Cantidad * (B.Cantidad + C.Cantidad) * 90) / 1000
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 10
        AND A.idTipoFase = 1;    
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 11
                AND B.idTipoFase = 1
    SET A.CostoUnitario = B.Cantidad / 49
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 10
        AND A.idTipoFase = 1;
		
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
                AND B.idTipoFase = 1
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 3    
                AND C.idTipoFase = 1
    SET A.Cantidad = B.Cantidad + C.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 14
        AND A.idTipoFase = 1;
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 15
                AND B.idTipoFase = 1
    SET A.CostoTotal = A.Cantidad * A.CostoUnitario * B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 14
        AND A.idTipoFase = 1;    
        
    ## Actualización Costo Total - Fase Lactancia	
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 3
                AND B.idTipoFase = 1
		INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 5
                AND C.idTipoFase = 1
    SET A.Cantidad = B.Cantidad * C.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 2
        AND A.idTipoFase = 2;
           
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
                AND B.idTipoFase = 2
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 9  
                AND C.idTipoFase = 2
    SET A.Cantidad = (C.Cantidad * B.Cantidad * 15) / 1000
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 7
        AND A.idTipoFase = 2; 
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 8
                AND B.idTipoFase = 2
    SET A.CostoUnitario = B.Cantidad / 11
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 7
        AND A.idTipoFase = 2;    
        
	UPDATE DetalleCosteo 
    SET CostoTotal = Cantidad * CostoUnitario
    WHERE dni = x_cdni
		AND idTipoCosteo = 7
        AND idTipoFase = 2;    
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 8
                AND B.idTipoFase = 1
    SET A.Cantidad = B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 8
        AND A.idTipoFase = 2;       
        
   ## Actualización Costo Total - Fase Recria
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
                AND B.idTipoFase = 3
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 2
                AND C.idTipoFase = 2
    SET A.Cantidad = (B.Cantidad - C.Cantidad) / C.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 3
        AND A.idTipoFase = 3;   
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
                AND B.idTipoFase = 3
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 9  
                AND C.idTipoFase = 3
    SET A.Cantidad = (C.Cantidad * B.Cantidad * 15) / 1000
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 7
        AND A.idTipoFase = 3; 
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 8
                AND B.idTipoFase = 3
    SET A.CostoUnitario = B.Cantidad / 11
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 7
        AND A.idTipoFase = 3;    
        
	UPDATE DetalleCosteo 
    SET CostoTotal = Cantidad * CostoUnitario
    WHERE dni = x_cdni
		AND idTipoCosteo = 7
        AND idTipoFase = 3;
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 8
                AND B.idTipoFase = 1
    SET A.Cantidad = B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 8
        AND A.idTipoFase = 3;  
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 11
                AND B.idTipoFase = 1
    SET A.Cantidad = B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 11
        AND A.idTipoFase = 3;  
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 12
                AND B.idTipoFase = 1
    SET A.Cantidad = B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 12
        AND A.idTipoFase = 3;   
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
                AND B.idTipoFase = 3
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 12  
                AND C.idTipoFase = 3
    SET A.Cantidad = (C.Cantidad * B.Cantidad * 15) / 1000
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 10
        AND A.idTipoFase = 3; 
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 11
                AND B.idTipoFase = 3
    SET A.CostoUnitario = B.Cantidad / 49
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 10
        AND A.idTipoFase = 3;    
        
	UPDATE DetalleCosteo 
    SET CostoTotal = Cantidad * CostoUnitario * 3
    WHERE dni = x_cdni
		AND idTipoCosteo = 10
        AND idTipoFase = 3;    
        
    ## Actualización Costo Total - Fase Engorde
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
                AND B.idTipoFase = 4
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 2
                AND C.idTipoFase = 3
    SET A.Cantidad = (B.Cantidad - C.Cantidad) / C.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 3
        AND A.idTipoFase = 4;  
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 8
                AND B.idTipoFase = 1
    SET A.Cantidad = B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 8
        AND A.idTipoFase = 4;    
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 11
                AND B.idTipoFase = 1
    SET A.Cantidad = B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 11
        AND A.idTipoFase = 4;   
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 12
                AND B.idTipoFase = 1
    SET A.Cantidad = B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 12
        AND A.idTipoFase = 4; 
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 14
                AND B.idTipoFase = 1
    SET A.CostoUnitario = B.CostoUnitario
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 14
        AND A.idTipoFase = 4;   
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
                AND B.idTipoFase = 4
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 9  
                AND C.idTipoFase = 4
    SET A.Cantidad = (C.Cantidad * B.Cantidad * 60) / 1000
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 7
        AND A.idTipoFase = 4; 
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 8
                AND B.idTipoFase = 4
    SET A.CostoUnitario = B.Cantidad / 11
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 7
        AND A.idTipoFase = 4;    
        
	UPDATE DetalleCosteo 
    SET CostoTotal = Cantidad * CostoUnitario
    WHERE dni = x_cdni
		AND idTipoCosteo = 7
        AND idTipoFase = 4;
        
	UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
                AND B.idTipoFase = 4
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 12  
                AND C.idTipoFase = 4
    SET A.Cantidad = (C.Cantidad * B.Cantidad * 60) / 1000
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 10
        AND A.idTipoFase = 4; 
        
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 11
                AND B.idTipoFase = 4
    SET A.CostoUnitario = B.Cantidad / 49
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 10
        AND A.idTipoFase = 4;    
        
	UPDATE DetalleCosteo 
    SET CostoTotal = Cantidad * CostoUnitario * 3
    WHERE dni = x_cdni
		AND idTipoCosteo = 10
        AND idTipoFase = 4;
        
   UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 2
                AND B.idTipoFase = 4
        INNER JOIN DetalleCosteo C
			ON A.dni = C.dni
				AND C.idTipoCosteo = 3  
                AND C.idTipoFase = 4
    SET A.Cantidad = C.Cantidad + B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 14
        AND A.idTipoFase = 4;      
    
    UPDATE DetalleCosteo A
		INNER JOIN DetalleCosteo B
			ON A.dni = B.dni
				AND B.idTipoCosteo = 15
                AND B.idTipoFase = 4
    SET A.CostoTotal = A.Cantidad * A.CostoUnitario * B.Cantidad
    WHERE A.dni = x_cdni
		AND A.idTipoCosteo = 14
        AND A.idTipoFase = 4;    
  END//
DELIMITER ;

/********************************************************/
DROP PROCEDURE IF EXISTS MantenimientoMargenContribucion_SP; 

DELIMITER //
CREATE PROCEDURE MantenimientoMargenContribucion_SP(
  IN x_cdni 		CHAR(8),
  IN x_nValor1 	DECIMAL(9,2),
  IN x_nValor2 	DECIMAL(9,2)
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Mantenimiento Margen Contribución
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL MantenimientoMargenContribucion_SP('45468034', 10.00, 12.50);
-------------------------------------------------------------------------------*/  
) BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;  
        ROLLBACK;   
    END;
    
    SET @inserted_rows = 0;
    
    START TRANSACTION;
		IF NOT EXISTS (SELECT 1 FROM DetalleConsolidado WHERE dni = x_cdni) THEN
			INSERT INTO DetalleConsolidado (dni, ValorVenta1, ValorVenta2, FechaRegistro)
									VALUES (x_cdni, x_nValor1, x_nValor2, CAST(NOW() AS DATE)); 
            SET @inserted_rows = ROW_COUNT() + @inserted_rows;                        
		ELSE
			UPDATE DetalleConsolidado 
            SET ValorVenta1 = x_nValor1,
				ValorVenta2 = x_nValor2
            WHERE dni = x_cdni;
			SET @inserted_rows = ROW_COUNT() + @inserted_rows;
        END IF;
        
    COMMIT;
    SELECT @inserted_rows AS inserted_rows;
  END//
DELIMITER ;

/********************************************************/
DROP PROCEDURE IF EXISTS MostrarConsolidado_SP; 

DELIMITER //
CREATE PROCEDURE MostrarConsolidado_SP(
  IN x_cdni 		CHAR(8)
/*-------------------------------------------------------------------------------
## Copyright © 2021 Ideas Solutions, All Rights Reserved
-- Autor       	Luis Pizarro Canto
-- Creación   	20.04.2021
-- Objetivo     Mostrar Consolidado Totales
--              
## Historial Modificaciones
	## Usuario      Fecha        Motivo<br>
	--
## Sintaxis Ejemplo
-- CALL MostrarConsolidado_SP('45468034');
-------------------------------------------------------------------------------*/  
) BEGIN
    
   SELECT  A.id, 
		   A.Nombre, 
		   A.Duracion, 
		   B.totalCostoVariable, 
		   C.CostoDiarioFijo * A.Duracion AS CostoTotalFijo,
		   B.totalCostoVariable / (CASE 
										WHEN A.id = 1 THEN D.Cantidad
										WHEN A.id = 2 THEN E.Cantidad
										WHEN A.id = 3 THEN F.Cantidad
										WHEN A.id = 4 THEN G.Cantidad
										ELSE 0
								   END ) AS Poblacion,
		   F.Cantidad AS CantidadRecria,
		   G.Cantidad AS CantidadEngorde,
		   H.ValorVenta1,
		   H.ValorVenta1
	FROM TipoFase A
		## Total Costos Variables
		INNER JOIN (SELECT idTipoFase, dni, SUM(CostoTotal) AS totalCostoVariable
					FROM DetalleCosteo
					GROUP BY idTipoFase, dni
					) B
			ON A.id = B.idTipoFase
				AND B.dni = x_cdni
		## Total Costos Fijos Diario        
		INNER JOIN (SELECT idTipoFase, dni, SUM(CostoUnitario) AS CostoDiarioFijo
					FROM DetalleCosteo
					GROUP BY idTipoFase, dni) C
			ON B.dni = C.dni
				AND C.idTipoFase = 5
		## Población Reproducción        
		INNER JOIN (SELECT dni, SUM(Cantidad) AS Cantidad
					FROM DetalleCosteo
					WHERE idTipoCosteo IN (2,3)	
						AND idTipoFase = 1
					GROUP BY dni) D
			ON B.dni = D.dni
		## Población Lactancia    
		INNER JOIN (SELECT dni, Cantidad 
					FROM DetalleCosteo
					WHERE idTipoCosteo = 2	
						AND idTipoFase = 2) E
			ON B.dni = E.dni 
		## Población Recría    
		INNER JOIN (SELECT dni, Cantidad
					FROM DetalleCosteo
					WHERE idTipoCosteo = 2
						AND idTipoFase = 3) F
			ON B.dni = F.dni
		## Población Engorde
		INNER JOIN (SELECT dni, Cantidad
					FROM DetalleCosteo
					WHERE idTipoCosteo = 2	
						AND idTipoFase = 4) G
			ON B.dni = G.dni    
		INNER JOIN DetalleConsolidado H
			ON B.dni = H.dni        
	WHERE A.id != 5;
   
  END//
DELIMITER ;

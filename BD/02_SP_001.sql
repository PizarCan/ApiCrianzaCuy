DROP PROCEDURE IF EXISTS LeerJson; 

DELIMITER //
CREATE PROCEDURE InsertarDetalleCosteo(
	IN x_Data JSON,
    IN x_Dni CHAR(8)
)
BEGIN
  SELECT
  A.item_id,
  A.model_number,
  CAST(
        CASE true 
            WHEN A.quantity = 'null'  -- handle string null
            THEN NULL 
            ELSE A.quantity 
            END as signed) as quantity
	FROM JSON_TABLE
	(
		x_Data
		, "$[*]"
		COLUMNS
		(
			item_id int PATH "$.item_id",
			model_number varchar(100) PATH "$.model_number",
			quantity varchar(100) PATH "$.quantity"
		)
	) A;
END//
DELIMITER ;


CALL LeerJson('[{"item_id":1,"model_number":"MFJA53","quantity":4},{"item_id":2,"model_number":"HSRHJN5","quantity":null},{"item_id":3,"model_number":"FAFAF1","quantity":345}]'); 
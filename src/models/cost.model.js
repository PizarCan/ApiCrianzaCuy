const query = require('../db/db-connection');
const { multipleColumnSet } = require('../utils/common.utils');
const Role = require('../utils/userRoles.utils');

class CostModel {

    /*create = async({ dni, jsonData }) => {

        const sql = 'CALL InsertarDetalleCosteo_SP(?,?)';
        const result = await query(sql, [dni, jsonData]);
        const affectedRows = result ? result.affectedRows : 0;

        return affectedRows;
    }*/

    insertUpdate = async({ jsonData }) => {

        const sql = 'CALL InsertarActualizarCosto_SP(?)';
        const result = await query(sql, [jsonData]);
        const affectedRows = result ? result.affectedRows : 0;
        return affectedRows;

    }

    findFixedCost = async(dni) => {

        let sql = 'CALL MostrarCostoFijo_SP(?)';

        return await query(sql, [dni]);
    }

    listCostResume = async(dni) => {

        let sql = 'CALL MostrarConsolidado_SP(?)';

        return await query(sql, [dni]);
    }

    findVariableCost = async({dni, tipo}) => {

        let sql = 'CALL MostrarDetalleCosteo_SP(?,?)';

        return await query(sql, [dni, tipo]);
    }

    maintenanceCost = async({dni, valorVenta1, valorVenta2}) => {

        let sql = 'CALL MantenimientoMargenContribucion_SP(?,?,?)';

        const result = await query(sql, [dni, valorVenta1, valorVenta2]);

        return result[0][0];;
    }
    
}

module.exports = new CostModel;
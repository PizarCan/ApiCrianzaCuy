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
        console.log(jsonData);
        const sql = 'CALL InsertarActualizarCosto_SP(?)';
        const result = await query(sql, [jsonData]);
        const affectedRows = result ? result.affectedRows : 0;
        console.log(result);
        return affectedRows;
    }

    findFixedCost = async(dni) => {

        let sql = 'CALL MostrarCostoFijo_SP(?)';

        return await query(sql, [dni]);
    }

    findVariableCost = async({dni, tipo}) => {

        let sql = 'CALL MostrarDetalleCosteo_SP(?,?)';

        return await query(sql, [dni, tipo]);
    }
}

module.exports = new CostModel;
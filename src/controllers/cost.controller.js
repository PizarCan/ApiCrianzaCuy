const CostModel = require('../models/cost.model');
const HttpException = require('../utils/HttpException.utils');
const { validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
dotenv.config();

/******************************************************************************
 *                              Cost Controller
 ******************************************************************************/

class CostController {

    createCostDetail = async(req, res, next) => {

        this.checkValidation(req);

        const result = await CostModel.create(req.body);

        if (!result) {
            throw new HttpException(500, 'Algo salió mal');
        }

        res.status(201).send('¡Se grabó correctamente!');
    };

    insertUpdateCost = async(req, res, next) => {

        this.checkValidation(req);

        const result = await CostModel.insertUpdate(req.body);

        if (!result) {
            throw new HttpException(500, 'Algo salió mal');
        }

        res.status(201).send('¡Se grabó correctamente!');
    };

    maintenanceContributionMargin = async(req, res, next) => {

        this.checkValidation(req);

        const result = await CostModel.maintenanceCost(req.body);

        if (!result) {
            throw new HttpException(500, 'Algo salió mal');
        }

        if (result.inserted_rows > 0)
            res.status(201).send('¡Se grabó correctamente!');
        else
            res.status(400).send('¡Ocurrió un problema en el mantenimiento!');
    };

    getCostResumeByDni = async(req, res, next) => {

        let costResumeList = await CostModel.listCostResume(req.params.dni);

        if (!costResumeList.length) {
            throw new HttpException(404, 'No se encontró el resumen de costos');
        }

        res.send(costResumeList[0]);
    };

    getCostVariableByDni = async(req, res, next) => {

        const costVariables = {dni: req.params.id, tipo: req.params.type}
        
        let costList = await CostModel.findVariableCost(costVariables);

        if (!costList.length) {
            throw new HttpException(404, 'No se encontró los costos variables');
        }

        res.send(costList[0]);
    };

    getCostFixedByDni = async(req, res, next) => {

        let costList = await CostModel.findFixedCost(req.params.id);

        if (!costList.length) {
            throw new HttpException(404, 'No se encontró los costos fijos');
        }

        res.send(costList[0]);
    };

    checkValidation = (req) => {
        const errors = validationResult(req)
        if (!errors.isEmpty()) {
            throw new HttpException(400, 'Error de Validación', errors);
        }
    }
}

module.exports = new CostController;
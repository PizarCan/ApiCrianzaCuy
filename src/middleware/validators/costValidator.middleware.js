const { body } = require('express-validator');
const Role = require('../../utils/userRoles.utils');

exports.createCostSchema = [
    body('jsonData')
        .exists()
        .withMessage('Json Detalle Costo es Requerido')
        .isLength({ min: 1 })
        .withMessage('Debe tener al menos 1 caracter')
];

exports.maintenanceCostSchema = [
    body('dni')
        .exists()
        .withMessage('DNI es requerido')
        .isLength({ min: 8 })
        .withMessage('Debe tener al menos 8 digitos')
        .isNumeric()
        .withMessage('Debe contener solo digitos'),
    body('valorVenta1')
        .exists()
        .withMessage('Valor Venta 1 es requerido')
        .isDecimal()
        .withMessage('Debe contener un valor decimal'),    
    body('valorVenta2')
        .exists()
        .withMessage('Valor Venta 2 es requerido')
        .isDecimal()
        .withMessage('Debe contener un valor decimal'),        
];


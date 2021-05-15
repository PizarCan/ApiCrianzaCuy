const { body } = require('express-validator');
const Role = require('../../utils/userRoles.utils');

exports.createCostSchema = [
    body('jsonData')
    .exists()
    .withMessage('Json Detalle Costo es Requerido')
    .isLength({ min: 1 })
    .withMessage('Debe tener al menos 1 caracter')
];
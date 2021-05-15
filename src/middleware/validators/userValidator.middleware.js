const { body } = require('express-validator');
const Role = require('../../utils/userRoles.utils');


exports.createUserSchema = [
    body('dni')
        .exists()
        .withMessage('DNI es requerido')
        .isLength({ min: 8 })
        .withMessage('Debe tener al menos 8 digitos')
        .isNumeric()
        .withMessage('Debe contener solo digitos'),
    body('nombres')
        .exists()
        .withMessage('Nombre es requerido')
        .isLength({ min: 3 })
        .withMessage('Debe tener al menos 3 caracteres'),
    body('apellidos')
        .exists()
        .withMessage('Apellidos es requerido')
        .isLength({ min: 3 })
        .withMessage('Debe tener al menos 3 caracteres'),
    body('role')
        .optional()
        .isIn([Role.Admin, Role.SuperUser])
        .withMessage('Tipo de rol no válido'),
    body('password')
        .exists()
        .withMessage('Password es requerido')
        .notEmpty()
        .isLength({ min: 6 })
        .withMessage('La contraseña debe contener al menos 6 caracteres')
        .isLength({ max: 10 })
        .withMessage('La contraseña puede contener un máximo de 10 caracteres'),
    body('confirm_password')
        .exists()
        .custom((value, { req }) => value === req.body.password)
        .withMessage('El campo confirm_password debe tener el mismo valor que el campo de contraseña')
];

exports.updateUserSchema = [
    body('username')
    .optional()
    .isLength({ min: 3 })
    .withMessage('Must be at least 3 chars long'),
    body('first_name')
    .optional()
    .isAlpha()
    .withMessage('Must be only alphabetical chars')
    .isLength({ min: 3 })
    .withMessage('Must be at least 3 chars long'),
    body('last_name')
    .optional()
    .isAlpha()
    .withMessage('Must be only alphabetical chars')
    .isLength({ min: 3 })
    .withMessage('Must be at least 3 chars long'),
    body('email')
    .optional()
    .isEmail()
    .withMessage('Must be a valid email')
    .normalizeEmail(),
    body('role')
    .optional()
    .isIn([Role.Admin, Role.SuperUser])
    .withMessage('Invalid Role type'),
    body('password')
    .optional()
    .notEmpty()
    .isLength({ min: 6 })
    .withMessage('Password must contain at least 6 characters')
    .isLength({ max: 10 })
    .withMessage('Password can contain max 10 characters')
    .custom((value, { req }) => !!req.body.confirm_password)
    .withMessage('Please confirm your password'),
    body('confirm_password')
    .optional()
    .custom((value, { req }) => value === req.body.password)
    .withMessage('confirm_password field must have the same value as the password field'),
    body('age')
    .optional()
    .isNumeric()
    .withMessage('Must be a number'),
    body()
    .custom(value => {
        return !!Object.keys(value).length;
    })
    .withMessage('Please provide required field to update')
    .custom(value => {
        const updates = Object.keys(value);
        const allowUpdates = ['username', 'password', 'confirm_password', 'email', 'role', 'first_name', 'last_name', 'age'];
        return updates.every(update => allowUpdates.includes(update));
    })
    .withMessage('Invalid updates!')
];

exports.validateLogin = [
    body('dni')
    .isLength({ min: 3 })
    .withMessage('DNI debe tener 8 digitos')
    .isNumeric()
    .withMessage('Debe Contener solo números')
    .exists()
    .withMessage('DNI es requerido'),
    body('password')
    .exists()
    .withMessage('Password es requerido')
    .notEmpty()
    .withMessage('Debe completar la contraseña')
];
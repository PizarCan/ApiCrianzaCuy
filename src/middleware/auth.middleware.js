const HttpException = require('../utils/HttpException.utils');
const UserModel = require('../models/user.model');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
dotenv.config();

const auth = (...roles) => {
    return async function(req, res, next) {
        try {
            const authHeader = req.headers.authorization;
            const bearer = 'Bearer ';

            if (!authHeader || !authHeader.startsWith(bearer)) {
                throw new HttpException(401, 'Acceso denegado. No se enviaron credenciales!');
            }

            const token = authHeader.replace(bearer, '');

            const secretKey = process.env.SECRET_JWT || "";

            // Verificar Token
            const decoded = jwt.verify(token, secretKey);

            const user = await UserModel.findOne({ dni: decoded.user_id });

            if (!user) {
                throw new HttpException(401, 'Autenticación fallida!');
            }

            // Comprobar si el usuario actual es el usuario propietario
            const ownerAuthorized = req.params.id == user.dni;

            // Si el usuario actual no es el propietario y
            // Si el rol de usuario no tiene permiso para realizar esta acción.
            // El usuario obtendrá este error
            if (!ownerAuthorized && roles.length && !roles.includes(user.role)) {
                throw new HttpException(401, 'No Autorizado');
            }

            // Si el usuario tiene permisos
            req.currentUser = user;
            next();

        } catch (e) {
            e.status = 401;
            next(e);
        }
    }
}

module.exports = auth;
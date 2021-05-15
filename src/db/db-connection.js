const dotenv = require('dotenv');
dotenv.config();
const mysql2 = require('mysql2');

class DBConnection {
    constructor() {
        this.db = mysql2.createPool({
            host: process.env.DB_HOST,
            user: process.env.DB_USER,
            password: process.env.DB_PASS,
            database: process.env.DB_DATABASE,
            port: process.env.DB_PORT
        });
        
        this.checkConnection();
    }

    checkConnection() {
        this.db.getConnection((err, connection) => {
            if (err) {
                if (err.code === 'PROTOCOL_CONNECTION_LOST') {
                    console.error('Se cerró la conexión a la base de datos.');
                }
                if (err.code === 'ER_CON_COUNT_ERROR') {
                    console.error('La base de datos tiene demasiadas conexiones.');
                }
                if (err.code === 'ECONNREFUSED') {
                    console.error('Se rechazó la conexión a la base de datos.');
                }
            }
            if (connection) {
                connection.release();
            }
            return
        });
    }

    query = async(sql, values) => {
       
        return new Promise((resolve, reject) => {
            const callback = (error, result) => {
                    if (error) {
                        reject(error);
                        return;
                    }
                    resolve(result);
                }
                // Ejecutar llamará internamente a preparar y consultar
            this.db.execute(sql, values, callback);
        }).catch(err => {
            const mysqlErrorList = Object.keys(HttpStatusCodes);
            // Convertir los errores de mysql que están en la lista mysqlErrorList al código de estado http
            err.status = mysqlErrorList.includes(err.code) ? HttpStatusCodes[err.code] : err.status;
            throw err;
        });
    }
}

// like ENUM
const HttpStatusCodes = Object.freeze({
    ER_TRUNCATED_WRONG_VALUE_FOR_FIELD: 422,
    ER_DUP_ENTRY: 409
});


module.exports = new DBConnection().query;
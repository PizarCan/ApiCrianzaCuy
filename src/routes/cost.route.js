const express = require('express');
const router = express.Router();
const userController = require('../controllers/cost.controller');
const auth = require('../middleware/auth.middleware');
const Role = require('../utils/userRoles.utils');
const awaitHandlerFactory = require('../middleware/awaitHandlerFactory.middleware');

const { createCostSchema } = require('../middleware/validators/costValidator.middleware');
const costController = require('../controllers/cost.controller');

//router.get('/', auth(), awaitHandlerFactory(userController.getAllUsers)); // localhost:3000/api/v1/users
//router.get('/id/:dni', auth(), awaitHandlerFactory(costController.getCostByDNI)); // localhost:3000/api/v1/costs/id/47238670
router.get('/id/:id/:type', awaitHandlerFactory(costController.getCostVariableByDni)); // localhost:3000/api/v1/costs/id/47238670
router.get('/id/:id', awaitHandlerFactory(costController.getCostFixedByDni)); // localhost:3000/api/v1/costs/id/47238670
router.post('/', createCostSchema, awaitHandlerFactory(costController.insertUpdateCost)); // localhost:3000/api/v1/users
//router.delete('/id/:id', auth(Role.Admin), awaitHandlerFactory(userController.deleteUser)); // localhost:3000/api/v1/users/id/1
module.exports = router;
const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const moment = require('moment');

async function receive (req, res, next) {
    const { shipid } = req.body;
    const sql = ``
    const value = []
    try {
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resSuccess(res, errorMessage.saveError)
    }
}

// =================================== ADMIN ===================================

module.exports = {
    receive
}
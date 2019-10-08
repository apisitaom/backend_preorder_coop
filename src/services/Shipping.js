const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const moment = require('moment');

async function add (req, res, next) {
    const { orderid } = req.body; 
    const sqlorderproduct = ``
    const valueorderproduct = []
    const sqlshipping = ``
    try {
        const valueshipping = []
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resSuccess(res, errorMessage.saveError)
    }
}
async function lists (req, res, next) {
    const sql = `select `
    const value = []
    try {

        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resSuccess(res, errorMessage.saveError)
    }
}
async function list (req, res, next) {
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

}
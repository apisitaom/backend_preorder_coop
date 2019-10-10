const db = require('../configdb/configDB');
const moment = require('moment')
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Response = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const productoptions = require('./options'); 

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ SELLER $$$$$$$$$$$$$$$$$$$$$$$$$$$$$

async function topproduct (req, res, next) {
    const sql = ``
    const value = []
    try {
        return Response.resSuccess(res, successMessage);
    } catch (error) {
        return Response.resError(res, errorMessage.saveError);
    }
}

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ADMIN $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

async function topseller (req, res, next) {
    const sql = ``
    const value = []
    try {
        return Response.resSuccess(res, successMessage);
    } catch (error) {
        return Response.resError(res, errorMessage);
    }
}

module.exports = {

}
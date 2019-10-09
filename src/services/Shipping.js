const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');

async function sellershipping (req, res, next) {
    const { shipid, shiptrackno } = req.body;
    const sqlpayment = `update shipping set shipstatusid = $1, shiptrackno = $2
    where shipid = $3`
    const valuepayment = [3, shiptrackno, shipid] //  3 = สินค้ายังทำการจัดส่งเรียบร้อยเเล้ว
    try {
        await db.query(sqlpayment, valuepayment);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}
async function adminshipping (req, res, next) {
    const { shipid } = req.body;
    const sqlpayment = `update shipping set shipstatusid = $1
    where shipid = $2`
    const valuepayment = [3, shiptrackno, shipid] // 3 = สินค้ายังทำการจัดส่งเรียบร้อยเเล้ว
    try {
        await db.query(sqlpayment, valuepayment);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}
async function customerreceive (req, res, next) {
    const { shipid } = req.body;
    const sqlpayment = `update shipping set shipstatusid = $1
    where shipid = $2`
    const valuepayment = [4, shiptrackno, shipid] // 4 = ยืนยันการจัดส่งเรียบร้อยเเล้ว
    try {
        await db.query(sqlpayment, valuepayment);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resSuccess(res, errorMessage.saveError)
    }
}
module.exports = {
    customerreceive,
    sellershipping,
    adminshipping
}
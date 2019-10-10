const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const moment = require('moment');
const productoptions = require('./productoptions');

async function add (req, res, next) {
    const {address, phonenumber, countdowntime, amount, proopid} = req.body;
    const active = true;
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    try {
            db.query('BEGIN');
            const sqlorderproduct = `insert into orderproduct (active, userid) values ($1, $2) returning orderid`
            const valueorderproduct = [active, decode.data.id];
            const orderproduct = await db.query(sqlorderproduct, valueorderproduct);
            const sqlorderdetail = `insert into orderdetail (active, amount, address, phone, proopids, orderid) values ($1, $2, $3, $4, $5, $6)`
            const valueorderdetail = [active, amount, address, phonenumber, proopid, orderproduct.rows[0].orderid];
            await db.query(sqlorderdetail, valueorderdetail);
            db.query('COMMIT');
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        db.query('REVOKE');
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function list (req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select * 
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    where orderproduct.userid = $1`
    try {
        const { rows } = await db.query(sql, [decode.data.id]);
        const tranfrom = await Promise.all(rows.map(async(item) => {
        const productoption = await productoptions.Productoption(item.proopids);
        return {
            orderdetailid: item.orderdetailid,
            amount: item.amount,
            address: item.address,
            orderid: item.orderid,
            phone: item.phone,
            result: productoption
            }
        }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}
module.exports = {
    add,
    list
}
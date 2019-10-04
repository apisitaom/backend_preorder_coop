const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const moment = require('moment');
const productoptions = require('./productoptions');

async function add (req, res, next) {
    const {address, phonenumber, countdowntime, amounts, proopid, district, province, zipcode} = req.body;
    if (amounts.length != proopid.length) {
        return Responce.resError(res, errorMessage.saveError);
    }
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
            const sqlorderdetail = `insert into orderdetail (active, amounts, address, phone, proopids, orderid, disstrict, province, zipcode) values ($1, $2, $3, $4, $5, $6, $7, $8, $9)`
            const valueorderdetail = [active, amounts, address, phonenumber, proopid, orderproduct.rows[0].orderid, district, province, zipcode];
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
async function lists (req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select * 
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join member on member.userid = orderproduct.userid 
    where orderproduct.userid = $1`
    try {
        const { rows } = await db.query(sql, [decode.data.id]);
        const tranfrom = await Promise.all(rows.map(async(item) => {
            const productoption = await productoptions.Productoption(item.proopids, item.amounts);
        return {
            fullname: item.firstname +' '+ item.lastname,
            createdate: item.createdate,
            orderid: item.orderid,
            orderdetailid: item.orderdetailid,
            amounts: item.amounts,
            address: item.address,
            disstrict: item.disstrict,
            province: item.province,
            zipcode: item.zipcode,
            orderid: item.orderid,
            phone: item.phone,
            result: productoption,
            }
        }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
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
    full join member on member.userid = orderproduct.userid 
    where orderproduct.userid = $1 and orderproduct.orderid = $2`
    const value = [decode.data.id, req.params.id]
    try {
        const { rows } = await db.query(sql, value);
        const tranfrom = await Promise.all(rows.map(async(item) => {
        const productoption = await productoptions.Productoption(item.proopids, item.amounts);
        return {
            fullname: item.firstname +' '+ item.lastname,
            createdate: item.createdate,
            orderid: item.orderid,
            orderdetailid: item.orderdetailid,
            amounts: item.amounts,
            address: item.address,
            disstrict: item.disstrict,
            province: item.province,
            zipcode: item.zipcode,
            orderid: item.orderid,
            phone: item.phone,
            result: productoption,
            }
        }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}

module.exports = {
    add,
    lists,
    list
}
const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment');
const helper = require('../lib/Helper');
const productoptions = require('./productoptions');

async function lists (req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select * 
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join member on member.userid = orderproduct.userid 
    where orderproduct.userid = $1`
    const value = [decode.data.id]
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
                statusname: item.statusname,
                result: productoption,
                }
            }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
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
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
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
            statusname: item.statusname,
            result: productoption,
            }
        }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}

async function add (req, res, next) {
    const {total, day, time, sellerid, orderid, payid} = req.body;  
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const date = day + ' ' + time;
    const active = true;    
        if (!req.files[0]) {
            return Responce.resError(res, errorMessage.photo);
        } else {
            const sqlPayment = `update payment set active = $1, datepayment = $2, summary = $3, slip = $4, paystatusid = $5 where payid = $6`
            const valuePayment = [active, moment(date).format('YYYY-MM-DD HH:mm:ss'), total, req.files[0].fieldname, 2, payid];    
            await db.query(sqlPayment, valuePayment);
            return Responce.resSuccess(res, successMessage.success);
        }
}
// =================================== ADMIN ===================================
async function adminLists (req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select * 
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join member on member.userid = orderproduct.userid`
    const value = [decode.data.id]
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
                statusname: item.statusname,
                result: productoption,
                }
            }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

module.exports = {
    lists,
    add,
    list,
    adminLists
}
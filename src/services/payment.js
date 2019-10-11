const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment');
const helper = require('../lib/Helper');
const productoptions = require('./options');

async function lists (req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select 
    orderdetail.orderdetailid, orderdetail.createdate, orderdetail.proopids, orderdetail.amounts,
    orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode, orderdetail.phone,
    member.firstname, member.lastname,
    orderproduct.orderid,
    paymentstatus.statusname, orderproduct.payid
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join member on member.userid = orderproduct.userid 
    where orderproduct.userid = $1`
    const value = [ decode.data.id ]
    try {
        const { rows } = await db.query(sql, value); 
        const tranfrom = await Promise.all(rows.map(async(item) => {
            const productoption = await productoptions.Productoption(item.proopids, item.amounts);
            return {
                fullname: item.firstname +' '+ item.lastname,
                createdate: item.createdate,
                orderid: item.orderid,
                orderdetailid: item.orderdetailid,
                address: item.address,
                disstrict: item.disstrict,
                province: item.province,
                zipcode: item.zipcode,
                orderid: item.orderid,
                phone: item.phone,
                statusname: item.statusname,
                payid: item.payid,
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
    const sql = `select 
    orderdetail.orderdetailid, orderdetail.createdate, orderdetail.proopids, orderdetail.amounts,
    orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode, orderdetail.phone,
    member.firstname, member.lastname,
    orderproduct.orderid,
    paymentstatus.statusname, orderproduct.payid
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
            address: item.address,
            disstrict: item.disstrict,
            province: item.province,
            zipcode: item.zipcode,
            orderid: item.orderid,
            phone: item.phone,
            statusname: item.statusname,
            payid: item.payid,
            result: productoption,
            }
        }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}

async function add (req, res, next) {
    const {total, day, time, payid} = req.body; 
     if (!total || !day || !time || !payid) {
        return Responce.resError(res, errorMessage.paramsNotMatch);
     }
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

async function adminpaymentlists (req, res, next) {
    const sql = `select 
    orderdetail.orderdetailid, orderdetail.createdate, orderdetail.proopids, orderdetail.amounts,
    orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode, orderdetail.phone,
    member.firstname, member.lastname,
    orderproduct.orderid,
    paymentstatus.statusname, orderproduct.payid
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join member on member.userid = orderproduct.userid 
    `
    try {
        const { rows } = await db.query(sql); 
        const tranfrom = await Promise.all(rows.map(async(item) => {
            if (item.proopids !== null) {
                const productoption = await productoptions.Productoption(item.proopids, item.amounts);
                return {
                    fullname: item.firstname +' '+ item.lastname,
                    createdate: item.createdate,
                    orderid: item.orderid,
                    orderdetailid: item.orderdetailid,
                    address: item.address,
                    disstrict: item.disstrict,
                    province: item.province,
                    zipcode: item.zipcode,
                    orderid: item.orderid,
                    phone: item.phone,
                    statusname: item.statusname,
                    payid: item.payid,
                    result: productoption,
                    }
            }
            }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function adminpaymentcheck (req, res, next) {
    const sql = `select 
    orderdetail.orderdetailid, orderdetail.createdate, orderdetail.proopids, orderdetail.amounts,
    orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode, orderdetail.phone,
    member.firstname, member.lastname,
    orderproduct.orderid,
    paymentstatus.statusname, orderproduct.payid
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join member on member.userid = orderproduct.userid 
    where payment.paystatusid = 2
    `
    try {
        const { rows } = await db.query(sql); 
        const tranfrom = await Promise.all(rows.map(async(item) => {
            if (item.proopids !== null) {
                const productoption = await productoptions.Productoption(item.proopids, item.amounts);
                return {
                    fullname: item.firstname +' '+ item.lastname,
                    createdate: item.createdate,
                    orderid: item.orderid,
                    orderdetailid: item.orderdetailid,
                    address: item.address,
                    disstrict: item.disstrict,
                    province: item.province,
                    zipcode: item.zipcode,
                    orderid: item.orderid,
                    phone: item.phone,
                    statusname: item.statusname,
                    payid: item.payid,
                    result: productoption,
                    }
            }
            }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function adminpaymentadd (req, res, next) {
        const { payid , orderid } = req.body;
        const active = true;
        const sqlpayment = `update payment set paystatusid = $1 where payid = $2`
        const valuepayment = [ 3, payid]; 
        const sqlshipping = `insert into shipping (active, shipstatusid) values ($1, $2) returning shipid`
        const valueshipping = [active, 1] 
        const sqlorderproduct = `update orderproduct set shipid = $1 where orderid = $2`
        try {
            const shipping = await db.query(sqlshipping, valueshipping);
            await db.query(sqlpayment, valuepayment);
            const valueorderproduct = [shipping.rows[0].shipid, orderid];
            await db.query(sqlorderproduct, valueorderproduct);
            return Responce.resSuccess(res, successMessage.success);
        } catch (error) {
            return Responce.resError(res, errorMessage.saveError);
    }
}

module.exports = {
    lists,
    add,
    list,
    adminpaymentlists,
    adminpaymentadd,
    adminpaymentcheck,
}
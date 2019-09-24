const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment');
const helper = require('../lib/Helper');

async function getPay (req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select 
    product.photo, product.prodetail, product.proname,
    productoption.sku, productoption.price,productoption.optionvalue
    from orderproduct 
    full join member on member.userid = orderproduct.userid
    full join orderdetail on orderdetail.orderid = orderproduct.orderid
    full join productoption on productoption.proopid = orderdetail.proopid
    full join product on product.proid =  productoption.proid
    where member.userid = $1`
    const value = [decode.data.id]
    try {
        const { rows } = await db.query(sql, value  );
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

//payment ต่อจาก cart/add
async function payment (req, res, next) {
    const {total, day, time, sellerid, } = req.body;  
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    
    const date = day + ' ' + time;
    
    const active = true;
    const sqlPayment = `insert into payment (active, datepayment, summary, slip) values  ($1, $2, $3, $4)`
    const valuePayment = [active, moment(date).format('YYYY-MM-DD HH:mm:ss'), total, req.files[0].filename];
    try {
        await db.query(sqlPayment, valuePayment);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function getOrderPayment(req, res, next) {
    const { orderid } = req.body;
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select 
    orderproduct.orderid,
    product.proname, product.photo,
    orderdetail.address, orderdetail.phonenumber,
    eventproduct.countdowntime,
    productoption.sku, productoption.price, productoption.includingvat, productoption.optionvalue
    from orderproduct 
    full join member on member.userid = orderproduct.userid
    full join orderdetail on orderdetail.orderid = orderproduct.orderid
    full join productoption on productoption.proopid = orderdetail.proopid
    full join shipping on shipping.shipid = orderproduct.shipid
    full join payment on payment.payid = orderproduct.payid
    full join product on product.proid =  productoption.proid
    full join eventdetail on  eventdetail.proopid = productoption.proopid
    full join eventproduct on eventproduct.eventid = eventdetail.eventid
    where member.userid = $1 and orderproduct.orderid = $2`
    const value = [decode.data.id, orderid];
    try {
        const { rows } = await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

module.exports = {
    getPay,
    payment,
    getOrderPayment
}
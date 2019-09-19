const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment');
const helper = require('../lib/Helper');

async function getPayment(req, res, next){

    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const value = [decode.data.id];
    const sql = `select 
    payment.createdate,
    product.proname,
    productoption.sku, productoption.price,
    productoption.optionvalue,
    paymentstatus.statusname
    from orderproduct
    full join orderdetail on orderdetail.orderid = orderproduct.orderid
    full join productoption on productoption.proopid = orderdetail.proopid
    full join product on product.proid = productoption.proid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    where orderproduct.userid = $1
    `
    try {
        const { rows } = await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function getPayment (req, res, next) {
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
async function payment (req, res, next) {
    const {total} = req.body
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const paymentstatusid = '641f8c00-1ec7-4a79-be69-b48a5716a496'; // ชำระเเล้ว
    const active = true;
    const sql = `insert into payment (active, datemodify, summary, slip, paystatusid) values  ($1, $2, $3, $4, $5)`
    const value = [active, date, total, req.files[0].filename, paymentstatusid];

    try {
        await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}


module.exports = {
    getPayment
}
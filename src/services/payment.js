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
    from orderproduct
    full join payment on orderproduct.payid = payment.payid
    full join orderdetail on orderdetail.orderid = orderproduct.orderid
    where orderproduct.userid = $1`
    const value = [decode.data.id]
    try {
        const { rows } = await db.query(sql, value);      
        const tranfrom = await Promise.all(rows.map(async(item) => {
            const productoption = await productoptions.Productoption(item.proopids);
            return {
                orderdetailid: item.orderdetailid,
                amount: item.amount,
                address: item.address,
                orderid: item.orderid,
                phone: item.phone,
                payid: item.payid,
                summary: item.summary,
                amount: item.amount,
                result: productoption
                }
            }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

//payment ต่อจาก cart/add
async function add (req, res, next) {
    const {total, day, time, sellerid, orderid} = req.body;  
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const date = day + ' ' + time;
    const active = true;    
        if (!req.files[0]) {
            return Responce.resError(res, errorMessage.photo);
        } else {
            const sqlPayment = `insert into payment (active, datepayment, summary, slip) values  ($1, $2, $3, $4) returning payid`
            const valuePayment = [active, moment(date).format('YYYY-MM-DD HH:mm:ss'), total, req.files[0].fieldname];    
            const orderproduct = await db.query(sqlPayment, valuePayment);
            const updateorderproduct = `update orderproduct set payid = $1 where orderid = $2`
            const valueorderproduct = [orderproduct.rows[0].payid, orderid];
            await db.query(updateorderproduct, valueorderproduct);
            return Responce.resSuccess(res, successMessage.success);
        }
}



module.exports = {
    lists,
    add
}
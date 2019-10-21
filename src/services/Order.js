const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const productoptions = require('./options');

async function add (req, res, next) {
    const {address, phonenumber, amounts, proopid, district, province, zipcode, sellerid} = req.body;
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
            const sqlpayment = `insert into payment(active, paystatusid) values ($1, $2) returning payid`
            const payment = await db.query(sqlpayment, [active, 1]);
            const sqlorderproduct = `insert into orderproduct (active, userid, payid, sellerid) values ($1, $2, $3, $4) returning orderid`
            const valueorderproduct = [active, decode.data.id,payment.rows[0].payid, sellerid];
            const orderproduct = await db.query(sqlorderproduct, valueorderproduct);
            amounts.map(async(element, index) => {
                const updateproductoption = `update productoption set totalproduct = totalproduct - $1 where proopid = $2`
                const valueupdateproductoption = [element, proopid[amounts.indexOf(element)] ]
                await db.query(updateproductoption, valueupdateproductoption);
            })
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
    const sql = `select 
    orderdetail.createdate, orderdetail.phone, orderdetail.proopids, orderdetail.amounts,
    member.lastname, member.firstname,
    orderproduct.orderid,
    orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode,
    payment.payid, 
    shipping.shiptrackno, shipping.shipid,
    shippingstatus.shippingstatusname, 
    paymentstatus.statusname
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join shipping on shipping.shipid = orderproduct.shipid
    full join shippingstatus on shippingstatus.shipstatusid = shipping.shipstatusid
    full join member on member.userid = orderproduct.userid 
    where orderproduct.userid = $1`
    try {
        const { rows } = await db.query(sql, [decode.data.id]);
        const tranfrom = await Promise.all(rows.map(async(item) => {
            const productoption = await productoptions.Productoption(item.proopids, item.amounts);
            let sum = 0;
            productoption.map(async(element, index) => {
                sum += element.totalprice;
            })
            return {
            fullname: item.firstname +' '+ item.lastname,
            createdate: item.createdate,
            orderid: item.orderid,
            orderdetailid: item.orderdetailid,
            address: item.address,
            disstrict: item.disstrict,
            province: item.province,
            zipcode: item.zipcode,
            phone: item.phone,
            payid: item.payid,
            shiptrackno: item.shiptrackno,
            shippingstatusname: item.shippingstatusname,
            shipid: item.shipid,
            statusname: item.statusname,
            total: sum,
            result: productoption
            }
        }));
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}

async function adminorder (req, res, next) {
    const sql = `select 
    orderdetail.createdate, orderdetail.phone, orderdetail.amounts,
    member.lastname, member.firstname,
    orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode,
    shipping.shiptrackno,
    shippingstatus.shippingstatusname, 
    paymentstatus.statusname
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join shipping on shipping.shipid = orderproduct.shipid
    full join shippingstatus on shippingstatus.shipstatusid = shipping.shipstatusid
    full join member on member.userid = orderproduct.userid 
    `
    let datas = []
    try {
        const { rows } = await db.query(sql);
        rows.map(async(item) => {
            if (item.createdate !== null) {
                let sum = item.amounts.reduce((index1, index2) => index1 + index2);
                let responce = {
                    fullname: item.firstname + ' ' + item.lastname,
                    phone: item.phone,
                    sum: sum,
                    address: item.address,
                    disstrict: item.disstrict,
                    province: item.province,
                    zipcode: item.zipcode,
                    shiptrackno: item.shiptrackno,
                    shippingstatusname: item.shippingstatusname,
                    statusname: item.statusname
                }
                datas.push(responce);
            }
        })
        return Responce.resSuccess(res, successMessage.success, datas);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
} 

module.exports = {
    add,
    lists,
    adminorder
}
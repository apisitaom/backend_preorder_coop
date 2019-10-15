const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const productoptions = require('./options');

async function sellershipping (req, res, next) {
    const { shipid, shiptrackno } = req.body;
    const sqlshipping = `update shipping set shipstatusid = $1, shiptrackno = $2
    where shipid = $3`
    const valueshipping = [3, shiptrackno, shipid] 
    try {
        await db.query(sqlshipping, valueshipping);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}

async function customerreceive (req, res, next) {
    const { shipid } = req.body;
    const sqlshipping = `update shipping set shipstatusid = $1
    where shipid = $2`
    const valueshipping = [4, shipid] 
    try {
        await db.query(sqlshipping, valueshipping);
        return Responce.resSuccess(res, successMessage.success, 'ยืนยันการจัดส่งเรียบร้อยเเล้ว');
    } catch (error) {
        return Responce.resSuccess(res, errorMessage.saveError);
    }
}

async function lists (req, res, next) {
    const sql = `select 
    orderdetail.orderdetailid, orderdetail.createdate, orderdetail.proopids, orderdetail.amounts,
    orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode, orderdetail.phone,
    member.firstname, member.lastname,
    orderproduct.orderid,
    paymentstatus.statusname, orderproduct.payid,
    shippingstatus.shippingstatusname
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join shipping on shipping.shipid = orderproduct.shipid
    full join shippingstatus on shippingstatus.shipstatusid = shipping.shipstatusid
    full join member on member.userid = orderproduct.userid 
    where shipping.shipstatusid = 3
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
                    shippingstatusname: item.shippingstatusname,
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

async function recieve (req, res, next) {
    const sql = `select 
    orderdetail.orderdetailid, orderdetail.createdate, orderdetail.proopids, orderdetail.amounts,
    orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode, orderdetail.phone,
    member.firstname, member.lastname,
    orderproduct.orderid,
    paymentstatus.statusname, orderproduct.payid,
    shippingstatus.shippingstatusname
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join payment on payment.payid = orderproduct.payid
    full join paymentstatus on paymentstatus.paystatusid = payment.paystatusid
    full join shipping on shipping.shipid = orderproduct.shipid
    full join shippingstatus on shippingstatus.shipstatusid = shipping.shipstatusid
    full join member on member.userid = orderproduct.userid 
    where shipping.shipstatusid = 4
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
                    shippingstatusname: item.shippingstatusname,
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

async function edit (req, res, next) {
    const { shiptrackno, shipid } = req.body;
    const sql = `update shipping set shiptrackno  = $1 where shipid = $2`
    const value = [ shiptrackno, shipid ]
    try {
        await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }

}
module.exports = {
    customerreceive,
    sellershipping,
    lists,
    recieve,
    edit
}

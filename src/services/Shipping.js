const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');

async function sellershipping (req, res, next) {
    const { shipid, shiptrackno } = req.body;
    const sqlshipping = `update shipping set shipstatusid = $1, shiptrackno = $2
    where shipid = $3`
    const valueshipping = [3, shiptrackno, shipid] //  3 = สินค้ายังทำการจัดส่งเรียบร้อยเเล้ว
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
    const valueshipping = [4, shipid] // 4 = ยืนยันการจัดส่งเรียบร้อยเเล้ว
    try {
        await db.query(sqlshipping, valueshipping);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resSuccess(res, errorMessage.saveError);
    }
}

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ADMIN $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

async function lists (req, res, next) {
    const sql = `select 
    * 
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join shipping on shipping.shipid = orderproduct.shipid
    full join shippingstatus on shipping.shipstatusid = shippingstatus.shipstatusid
    full join member on member.userid = orderproduct.userid`
    let data = [];
    try {
        const { rows } = await db.query(sql);
        rows.map(async(element ,index) => {
            if (element.orderid != null) {
                let responce = {
                    payid: element.payid,
                    orderid: element.orderid,
                    phone: element.phone,
                    disstrict: element.disstrict,
                    province: element.province,
                    zipcode: element.zipcode,
                    shiptrackno: element.shiptrackno,
                    shippingstatusname: element.shippingstatusname,
                    fullname: element.firstname + ' '+ element.lastname,
                    gender: element.gender,
                    email: element.email,
                }
                data.push(responce);
            }
        })
        return Responce.resSuccess(res, successMessage.success, data);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function recieve (req, res, next) {
    const sql = `select 
    * 
    from orderdetail 
    full join orderproduct on orderproduct.orderid = orderdetail.orderid
    full join shipping on shipping.shipid = orderproduct.shipid
    full join shippingstatus on shipping.shipstatusid = shippingstatus.shipstatusid
    full join member on member.userid = orderproduct.userid
    where shipping.shipstatusid = 4`
    let data = [];
    try {
        const { rows } = await db.query(sql);
        rows.map(async(element ,index) => {
            if (element.orderid != null) {
                let responce = {
                    payid: element.payid,
                    orderid: element.orderid,
                    phone: element.phone,
                    disstrict: element.disstrict,
                    province: element.province,
                    zipcode: element.zipcode,
                    shiptrackno: element.shiptrackno,
                    shippingstatusname: element.shippingstatusname,
                    fullname: element.firstname + ' '+ element.lastname,
                    gender: element.gender,
                    email: element.email,
                }
                data.push(responce);
            }
        })
        return Responce.resSuccess(res, successMessage.success, data);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

module.exports = {
    customerreceive,
    sellershipping,
    lists,
    recieve
}
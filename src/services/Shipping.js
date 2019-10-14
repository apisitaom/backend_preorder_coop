const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment')

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
    const sqlSelectJoin = `
    select 	orderproduct.orderid, orderproduct.sellerid, orderproduct.createdate, 
		shipping.shipid, orderdetail.proopids, orderdetail.amounts,
		member.userid, member.firstname, member.lastname, orderdetail.province, member.gender, extract(year from member.brithday) as brithday
    from orderproduct
    inner join shipping
        on orderproduct.shipid = shipping.shipid
    inner join orderdetail
        on orderproduct.orderid = orderdetail.orderid
    inner join member
        on orderproduct.userid = member.userid
    where shipping.shipid = $1
    `
    const sqlSelectSeller = `
        select sellerid, sellername from seller
        where sellerid = $1
    `
    const sqlSelectProduct = `
        select 
            product.proid, product.proname,
            productoption.proopid, productoption.sku, productoption.price, productoption.includingvat, productoption.optionvalue
        from productoption
        inner join product
            on productoption.proid = product.proid 
        where productoption.proopid = $1
    `
    const sqlInsertToRecipt = `
        insert into receipt(createdate, quantity, grand_price, province, gender, age, customer_id, customer_name, order_id)
        values($1, $2, $3, $4, $5, $6, $7, $8, $9) returning receipt_id
    `
    const sqlInsertToReceiptDetail = `
        insert into receipt_detail(seller_id, seller_name, proid, product_name, product_option_id, option_value, sku, price, vat, grand_price, amount, receipt_id)
        values($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
    `
    let arrSeller = []
    let arrProduct = []
    let arrReceipt = []
    let sumAmount = 0
    let sumPrice = 0
    const year = new Date().getFullYear()
    try {
        const valueReceipt = await db.query(sqlSelectJoin, [shipid])
        console.log(valueReceipt.rows[0])
        for(let i = 0; i <  valueReceipt.rows[0].sellerid.length; i++) {
            const valueSeller = await db.query(sqlSelectSeller, [valueReceipt.rows[0].sellerid[i]])
            arrSeller.push(valueSeller.rows[0])
        }
        for(let i = 0; i <  valueReceipt.rows[0].sellerid.length; i++) {
            const valueProduct = await db.query(sqlSelectProduct, [valueReceipt.rows[0].proopids[i]])
            arrProduct.push(valueProduct.rows[0])
        }
        const arrSumAmount = valueReceipt.rows[0].amounts.map( e => {
            sumAmount += parseInt(e)
            return sumAmount
        })
        for(let i = 0; i < valueReceipt.rows[0].amounts.length; i++){
            sumPrice += parseInt(valueReceipt.rows[0].amounts[i]) * parseInt(arrProduct[i].price)
        }
        const age = parseInt(year) - parseInt(valueReceipt.rows[0].brithday)
        const insertValueReceipt = [
            valueReceipt.rows[0].createdate,
            arrSumAmount[valueReceipt.rows[0].amounts.length-1],
            sumPrice,
            valueReceipt.rows[0].province,
            valueReceipt.rows[0].gender,
            age,
            valueReceipt.rows[0].userid,
            valueReceipt.rows[0].firstname + " " + valueReceipt.rows[0].lastname,
            valueReceipt.rows[0].orderid
        ]
        await db.query('begin')
        const { rows } = await db.query(sqlInsertToRecipt, insertValueReceipt)
        for(let i = 0; i < valueReceipt.rows[0].amounts.length; i++){        
            const insertValueReceiptDetail = [
                arrSeller[i].sellerid,
                arrSeller[i].sellername,
                arrProduct[i].proid,
                arrProduct[i].proname,
                arrProduct[i].proopid,
                arrProduct[i].optionvalue,
                arrProduct[i].sku,
                arrProduct[i].price - arrProduct[i].includingvat,
                arrProduct[i].includingvat,
                arrProduct[i].price,
                valueReceipt.rows[0].amounts[i],
                rows[0].receipt_id
            ]
            await db.query(sqlInsertToReceiptDetail, insertValueReceiptDetail)
        }
        await db.query('commit')
        await db.query(sqlshipping, valueshipping);
        return Responce.resSuccess(res, successMessage.success, "ยืนยันการจัดส่งเรียบร้อยเเล้ว");
    } catch (error) {
        console.log(error)
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
                    createdate: moment(element.createdate).format('YYYY-MM-DD HH:mm:ss'),
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
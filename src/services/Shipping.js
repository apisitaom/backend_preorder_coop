const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const productoptions = require('./options');
const moment = require('moment')

module.exports = {
    customerreceive,
    sellershipping,
    lists,
    recieve,
    edit
}

async function sellershipping (req, res) {
    const { shipid, shiptrackno } = req.body;
    const sqlshipping = `
        update shipping 
        set shipstatusid = $1, shiptrackno = $2
        where shipid = $3`
    const valueshipping = [3, shiptrackno, shipid] 
    try {
        await db.query(sqlshipping, valueshipping);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}

async function customerreceive (req, res) {
    const { shipid } = req.body;
    const sqlshipping = `
        update shipping 
        set shipstatusid = $1 
        where shipid = $2`
    const valueshipping = [4, shipid] 
    const sqlSelectOrder = `
        select
        orderproduct.createdate, orderproduct.orderid, orderdetail.proopids, orderproduct.userid, orderproduct.orderid, orderdetail.amounts as quantity, orderproduct.sellerid,
            orderdetail.address, orderdetail.phone, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode,
            member.userid, member.firstname, member.lastname, member.gender, extract(year from member.brithday) as brithday
        from orderproduct
        inner join orderdetail
            on orderproduct.orderid = orderdetail.orderid
        inner join member
            on orderproduct.userid = member.userid
        where shipid = $1
    `
    const sqlSelectSeller = `
        select 
            sellerid, sellername 
        from seller 
        where sellerid = $1
    `
    const sqlSelectProductOption = `
        select 
            product.proid, product.proname, productoption.proopid, productoption.price, 
            productoption.includingvat as vat, productoption.sku , productoption.optionvalue
        from productoption 
        inner join product
            on productoption.proid = product.proid
        where proopid = $1
    `
    const insertReceip = `
        INSERT INTO 
            receipt(createdate, quantity, grand_price, province, gender, age, customer_id,
                     customer_name, order_id, life_span, day)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        returning receipt_id
    `
    const insertReceiptDetail = `
        INSERT INTO 
            receipt_detail(seller_id, seller_name, proid, product_name, product_option_id, option_value, 
                    sku, price, vat, grand_price, amount, receipt_id)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
    `
    try {
        let arrSeller = []
        let arrProductOption = []
        let amountValue = 0
        let totalPrice = 0, life_span = 0
        const day = new Date()
        const a = day.getFullYear()
        const valueOrder = await db.query(sqlSelectOrder, [shipid])
        for(let i = 0; i< valueOrder.rows[0].sellerid.length; i++){
            const valueSeller = await db.query(sqlSelectSeller, [valueOrder.rows[0].sellerid[i]])
            arrSeller.push(valueSeller.rows[0])
        }
        for(let i = 0; i< valueOrder.rows[0].proopids.length; i++){
            const valueProductOption = await db.query(sqlSelectProductOption, [valueOrder.rows[0].proopids[i]])
            arrProductOption.push(valueProductOption.rows[0])
        }
        for(let i = 0; i<valueOrder.rows[0].quantity.length; i++){
            amountValue += parseInt(valueOrder.rows[0].quantity[i])
            totalPrice += (parseInt(valueOrder.rows[0].quantity[i]) * arrProductOption[i].price)
        }
        const age = parseInt(a) - parseInt(valueOrder.rows[0].brithday)
        if(age >= 0 && age < 30){
            life_span = 'adolescence'
        }else if(age > 29 && age < 60){
            life_span = 'adult'
        }else if(age > 59 && age < 100){
            life_span = 'elder'
        }else{
            life_span = 'unknow'
        }
        const valueForInsert = [ day, amountValue, totalPrice, valueOrder.rows[0].province, valueOrder.rows[0].gender, age, valueOrder.rows[0].userid, valueOrder.rows[0].firstname + " " +valueOrder.rows[0].lastname, valueOrder.rows[0].orderid, life_span , moment(day).format('dddd')]
        const valueReceiptID = await db.query(insertReceip, valueForInsert)
        for(let i = 0; i < arrProductOption.length; i++){
            const data = [
                arrSeller[i].sellerid,
                arrSeller[i].sellername,
                arrProductOption[i].proid,
                arrProductOption[i].proname,
                arrProductOption[i].proopid,
                arrProductOption[i].optionvalue,
                arrProductOption[i].sku,
                parseInt(arrProductOption[i].price) - parseInt(arrProductOption[i].vat),
                arrProductOption[i].vat,
                parseInt(arrProductOption[i].price) * parseInt(valueOrder.rows[0].quantity[i]),
                valueOrder.rows[0].quantity[i],
                valueReceiptID.rows[0].receipt_id
            ]
            await db.query(insertReceiptDetail, data)
        }
        await db.query(sqlshipping, valueshipping);
        return Responce.resSuccess(res, successMessage.success, 'ยืนยันการจัดส่งเรียบร้อยเเล้ว');
    } catch (error) {
        console.log(error)
        return Responce.resSuccess(res, errorMessage.saveError);
    }
}

async function lists (req, res) {
    const sql = `
        select 
            orderdetail.orderdetailid, orderdetail.createdate, orderdetail.proopids, orderdetail.amounts,
            orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode, orderdetail.phone,
            member.firstname, member.lastname, orderproduct.orderid, paymentstatus.statusname, orderproduct.payid,
            shippingstatus.shippingstatusname
        from orderdetail 
        full join orderproduct 
            on orderproduct.orderid = orderdetail.orderid
        full join payment 
            on payment.payid = orderproduct.payid
        full join paymentstatus 
            on paymentstatus.paystatusid = payment.paystatusid
        full join shipping 
            on shipping.shipid = orderproduct.shipid
        full join shippingstatus 
            on shippingstatus.shipstatusid = shipping.shipstatusid
        full join member 
            on member.userid = orderproduct.userid 
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

async function recieve (req, res) {
    const sql = `
        select 
            orderdetail.orderdetailid, orderdetail.createdate, orderdetail.proopids, orderdetail.amounts,
            orderdetail.address, orderdetail.disstrict, orderdetail.province, orderdetail.zipcode, orderdetail.phone,
            member.firstname, member.lastname, orderproduct.orderid, paymentstatus.statusname, orderproduct.payid,
            shippingstatus.shippingstatusname
        from orderdetail 
        full join orderproduct 
            on orderproduct.orderid = orderdetail.orderid
        full join payment 
            on payment.payid = orderproduct.payid
        full join paymentstatus 
            on paymentstatus.paystatusid = payment.paystatusid
        full join shipping 
            on shipping.shipid = orderproduct.shipid
        full join shippingstatus 
            on shippingstatus.shipstatusid = shipping.shipstatusid
        full join member 
            on member.userid = orderproduct.userid 
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

async function edit (req, res) {
    const { shiptrackno, shipid } = req.body;
    const sql = `
        update shipping 
        set shiptrackno  = $1 
        where shipid = $2`
    const value = [ shiptrackno, shipid ]
    try {
        await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }

}
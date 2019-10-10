const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const moment = require('moment')

const Product = {
    async getPopup(req, res) {
        const detail = []
        const getPopup = `select 
        product.proid,product.photo,product.proname, product.prodetail,
        productoption.price,productoption.sku,productoption.includingvat ,productoption.optionvalue
        from product
        inner join productoption on product.proid = productoption.proid 
        where product.proid = $1` ;
        try {
            const { rows } = await db.query(getPopup, [req.params.id]);
            for (let i = 0; i < rows.length; i++) {
                let obj = {
                    'price': rows[i].price,
                    'optionvalue': rows[i].optionvalue,
                    'sku': rows[i].sku,
                    'vat': rows[i].includingvat
                }
                detail.push(obj)
            }
            const tranfrom = {
                photo: rows[0].photo,
                proname: rows[0].proname,
                detail: rows[0].prodetail,
                results: detail
            }
            return Responce.resSuccess(res, successMessage.success, tranfrom);
        } catch (error) {
            return Responce.resError(res, errorMessage.saveError);
        }
    },
    async getMaxMin(req, res) {
        try {
            const selectMin = `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MIN (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
            const selectMax = `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MAX (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
            const selectProduct = 'select proid,proname from product'
            const result = await db.query(selectProduct)
            let sumValue = []
            let price, allValue
            for (let i = 0; i < (result.rows).length; i++) {
                const id = result.rows[i].proid
                const queryMax = await db.query(selectMax, [id])
                const queryMin = await db.query(selectMin, [id])
                const max = queryMax.rows[i].price
                const min = queryMin.rows[i].price
                const proName = result.rows[i].proname
                price = min + ' - ' + max
                allValue = {
                    order: i + 1,
                    proid: id,
                    proname: proName,
                    price: price
                }
                sumValue.push(allValue)
            }
            return Responce(res, successMessage.success, sumValue);
        } catch (error) {
            return Responce.resError(res, errorMessage.saveError);
        } finally {
            res.end();
        }
    }
}
async function homepageCustomer(req, res, next) {
        const sql = `select proid,proname,prodetail,photo,sellerid,timestart,timeend from product where active = true`;
        let products = [];
        const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        try {
            const product = await db.query(sql);
            await Promise.all(product.rows.map(async(item) => {
            const option = await getOption(item.proid);
            if(item.timestart !== null){
            item.timeend = moment(item.timeend).subtract(7, 'h');
            item.timeend = moment(item.timeend).format('YYYY-MM-DD HH:mm:ss');
            item.timestart = moment(item.timestart).format('YYYY-MM-DD HH:mm:ss');                    
            const addTime = item.timeend = moment(item.timeend).add(7, 'h');
            const endTime = item.timeend = moment(addTime).format('YYYY-MM-DD HH:mm:ss');
            const startTime = item.timestart = moment(item.timestart).format('YYYY-MM-DD HH:mm:ss');
            if (endTime > date && date > startTime) {
                let obj = {
                    proid: item.proid,
                    proname: item.proname,
                    prodetail: item.prodetail,
                    photo: item.photo,
                    sellerid: item.sellerid,
                    timestart:item.timestart,
                    timeend: item.timeend,
                    time : moment(item.timeend).format('mm:ss'),
                    hour: moment(item.timeend).format('HH'),
                    result :option,
                }
                products.push(obj);
            }
        }
            }));
            return Responce.resSuccess(res, successMessage.success, products);
        } catch (error) {
            return Responce.resError(res, errorMessage.saveError);
        } finally {
            res.end();
        }
}
async function getOption (productid) {
    const sql = `select productoption.proopid,productoption.sku,productoption.price,productoption.includingvat,productoption.optionvalue,productoption.totalproduct from productoption where types ='preorder' and proid = $1`
    return new Promise(async(resolve , reject) => {
        try {
            const { rows } = await db.query(sql, [productid]);
            resolve(rows);
            res.end();
        } catch (error) {
            reject(error)
        }
    });
}
async function insertProductHomepage(req, res, next) {
    const { amount, userid, proopid } = req.body;
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const active = true;
    // ORDER PRODUCT
    const sqlOrderProduct = `insert into orderproduct (active, userid) values ($1, $2) returning orderid`
    const valuesOrderProduct = [active, userid];
    const sqlOrderDetail = `insert into orderdetail (active, amount, proopid, orderid) values ($1, $2, $3, $4)`
    try {
        await db.query('BEGIN');
        // ORDER PRODUCT
        const orderproduct = await db.query(sqlOrderProduct, valuesOrderProduct);
        // ORDER DETAIL
        const valuesOrderDetail = [active, amount, proopid, orderproduct.rows[0].orderid];
        await db.query(sqlOrderDetail, valuesOrderDetail);
        await db.query('COMMIT');
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        await db.query('REVOKE');
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function getCartCustomer(req, res, next) {
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
    where member.userid = $1`
    const value = [decode.data.id];
    try {
        const { rows } = await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function cartCustomer(req, res, next) {
    const { productname, address, phonenumber, countdowntime, amount , sellerid} = req.body
    const optionJson = JSON.parse(req.body.option);
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const active = true;
    let data = req.files.map((item, index) => item.filename);
    const picture = [];
    picture.push(data);
    // MEMBER
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    // PRODUCT 
    const sqlProduct = `insert into product (active, proname, photo, userid, sellerid) values ($1, $2, $3, $4, $5) returning proid`
    const valueProduct = [active, productname, data, decode.data.id, sellerid];
    // EVENT PRODUCT
    const sqlEventProduct = `insert into eventproduct (active, countdowntime) values ($1, $2) returning eventid`
    const valueEventProduct = [active, countdowntime]; // I change count downtime is timestamp!

    //EVENT DETIAL
    const sqlEventDetail = `insert into eventdetail (eventid, proopid) values ($1, $2);`
    // SHIPPING  
    const sqlShipping = `insert into shipping (active) values ($1) returning shipid`
    const valueShipping = [active];
    // PAYMENT  
    const sqlPayment = `insert into payment (active )values ($1) returning payid`
    const valuePayment = [active];
    // ORDER PRODUCT
    const sqlOrderProduct = `insert into orderproduct (active, userid, payid, shipid, eventid) values ($1, $2, $3, $4, $5) returning orderid`
    // ORDER DETAIL
    const sqlOrderDetail = `insert into orderdetail (active, amount, address, phonenumber, orderid, proopid) values ($1, $2, $3, $4, $5, $6)`
    try {
        const product = await db.query(sqlProduct, valueProduct);
        const eventproduct = await db.query(sqlEventProduct, valueEventProduct);
        const sqlProductoption = 'INSERT INTO productoption(active,datemodify,sku,price,optionvalue,proid,includingvat) VALUES($1,$2,$3,$4,$5,$6,$7) returning proopid'
        optionJson.forEach(async (element, index) => {                                                         // edit product ID
        const valueProductoption = [active, date, optionJson[index].sku, optionJson[index].price, optionJson[index].optionvalue, product.rows[0].proid, optionJson[index].vat]
        const productoption = await db.query(sqlProductoption, valueProductoption);
        const valueEventDetail = [eventproduct.rows[0].eventid, productoption.rows[0].proopid]; // use in "try"
        await db.query(sqlEventDetail, valueEventDetail);
        const shipping = await db.query(sqlShipping, valueShipping);
        const payment = await db.query(sqlPayment, valuePayment);
        const valueOrderProduct = [active, decode.data.id, payment.rows[0].payid, shipping.rows[0].shipid, eventproduct.rows[0].eventid]; // use in "try"  
        const orderproduct = await db.query(sqlOrderProduct, valueOrderProduct);
        productoption.rows.map(index => {
            const valueOrderDetail = [active, amount, address, phonenumber, orderproduct.rows[0].orderid, index.proopid]; // use in "try"
            db.query(sqlOrderDetail, valueOrderDetail);
        })
        });
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function shopCustomer(req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select 
    product.photo, product.proname, 
    seller.address, seller.subdistrict, seller.district, seller.zipcode, 
    seller.province, seller.phonenumber, seller.email, seller.photo, 
    eventproduct.timestart, 
    eventproduct.timeend, eventproduct.timeend,
    productoption.sku, productoption.price, productoption.includingvat, productoption.optionvalue  
    from product 
    full join seller on seller.sellerid = product.sellerid
    full join productoption on productoption.proid = product.proid 
    full join eventdetail on eventdetail.proopid = productoption.proid 
    full join eventproduct on eventproduct.eventid = eventdetail.eventid 
    where seller.sellerid = $1`
    const value = [decode.data]
    try {
        const { rows } = await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        return Responce.resSuccess(res, successMessage.success);
    } finally {
        res.end();
    }
}
async function getProduct(req, res) {
    const detail = []
    const getPopup = `select 
    product.proid,product.photo,product.proname, product.prodetail,
    productoption.proopid,productoption.price,productoption.sku,productoption.includingvat ,productoption.optionvalue,
    seller.sellername,seller.sellerid
    from product
    inner join productoption on product.proid = productoption.proid
    full join seller on seller.sellerid = product.sellerid 
    where product.proid = $1` ;
    try {
        const { rows } = await db.query(getPopup, [req.params.id]);
        for (let i = 0; i < rows.length; i++) {
            let obj = {
                'proopid': rows[i].proopid,
                'price': rows[i].price,
                'optionvalue': rows[i].optionvalue,
                'sku': rows[i].sku,
                'vat': rows[i].includingvat
            }
            detail.push(obj)
        }
        const tranfrom = {
            proid: rows[0].proid,
            sellername: rows[0].sellername,
            sellerid: rows[0].sellerid,
            photo: rows[0].photo,
            proname: rows[0].proname,
            detail: rows[0].prodetail,
            result: detail
        }
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}
async function preOrder( req, res, next) {
    const {productid, date, time, hour} = req.body;
    const optionJson = JSON.parse(req.body.option);
    const active = true;
    //หาเวลาสิ้นสุดของการ Pre-order
    const days = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const dates = date +' '+ time;
    const ends = moment(dates).format('YYYY-MM-DD HH:mm:ss');
    const end = moment(ends).add(hour, 'h');
    const types = 'preorder';
    try {
        const sqlProduct = `select * from product where proid = $1`;
        const valueProduct = [productid];
        const { rows } = await db.query(sqlProduct, valueProduct);
        const sql = `insert into product (active, proname, prodetail, photo, sellerid, timestart, timeend) values ($1, $2, $3, $4, $5, $6, $7) returning proid`;
        const value = [active,rows[0].proname, rows[0].prodetail, rows[0].photo, rows[0].sellerid, days, new Date(end.toString())];
        const product = await db.query(sql, value);
            optionJson.forEach(async (element, index) => {                
                const sqlProductoption = `insert into productoption (active, sku, price, optionvalue,includingvat, proid, types, totalproduct) values ($1, $2, $3, $4, $5, $6, $7, $8) returning proopid `;
                const valueProductoption = [active, optionJson[index].sku, optionJson[index].price, optionJson[index].optionvalue, optionJson[index].vat, product.rows[0].proid, types, optionJson[index].amount];
                await db.query (sqlProductoption, valueProductoption);
});
return Responce.resSuccess(res, successMessage.success);
} catch (error) {
    db.query('REVOKE');
    return Responce.resError(res, errorMessage.saveError);
    }
}

module.exports = {
    Product,
    getCartCustomer,
    homepageCustomer,
    insertProductHomepage,
    shopCustomer,
    getProduct,
    cartCustomer,
    preOrder
}
const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');
const moment = require('moment')
const productoptions = require('./options');

async function list (req, res) {
    const detail = []
    const sql = `select 
    product.proid,product.photo,product.proname, product.prodetail,product.category,
    productoption.proopid ,productoption.price,productoption.sku,productoption.includingvat ,productoption.optionvalue
    from product
    inner join productoption on product.proid = productoption.proid 
    where product.proid = $1 `;
    try {
        const { rows } = await db.query(sql, [req.params.id]);
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
            photo: rows[0].photo,
            proname: rows[0].proname,
            detail: rows[0].prodetail,
            category: rows[0].category,
            results: detail
        }
        return Responce.resSuccess(res, successMessage.success, tranfrom);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}

async function homepage(req, res, next) {
        const sql = `select proid,proname,prodetail,photo,sellerid,timestart,timeend,category from product where active = true`;
        let products = [];
        const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        try {
            const product = await db.query(sql);
            await Promise.all(product.rows.map(async(item) => {
            const option = await productoptions.option(item.proid);
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
                    category: item.category,
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

async function addhomepage(req, res, next) {
    const { amount, userid, proopid } = req.body;
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const active = true;
    const sqlOrderProduct = `insert into orderproduct (active, userid) values ($1, $2) returning orderid`
    const valuesOrderProduct = [active, userid];
    const sqlOrderDetail = `insert into orderdetail (active, amount, proopid, orderid) values ($1, $2, $3, $4)`
    try {
        await db.query('BEGIN');
        const orderproduct = await db.query(sqlOrderProduct, valuesOrderProduct);
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

async function orderlists (req, res, next) {
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

async function orderadd(req, res, next) {
    const { productname, address, phonenumber, countdowntime, amount , sellerid} = req.body
    const optionJson = JSON.parse(req.body.option);
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const active = true;
    let data = req.files.map((item, index) => item.filename);
    const picture = [];
    picture.push(data);
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sqlProduct = `insert into product (active, proname, photo, userid, sellerid) values ($1, $2, $3, $4, $5) returning proid`
    const valueProduct = [active, productname, data, decode.data.id, sellerid];
    const sqlEventProduct = `insert into eventproduct (active, countdowntime) values ($1, $2) returning eventid`
    const valueEventProduct = [active, countdowntime]; 
    const sqlEventDetail = `insert into eventdetail (eventid, proopid) values ($1, $2);`
    const sqlShipping = `insert into shipping (active) values ($1) returning shipid`
    const valueShipping = [active];
    const sqlPayment = `insert into payment (active )values ($1) returning payid`
    const valuePayment = [active];
    const sqlOrderProduct = `insert into orderproduct (active, userid, payid, shipid, eventid) values ($1, $2, $3, $4, $5) returning orderid`
    const sqlOrderDetail = `insert into orderdetail (active, amount, address, phonenumber, orderid, proopid) values ($1, $2, $3, $4, $5, $6)`
    try {
        const product = await db.query(sqlProduct, valueProduct);
        const eventproduct = await db.query(sqlEventProduct, valueEventProduct);
        const sqlProductoption = 'INSERT INTO productoption(active,datemodify,sku,price,optionvalue,proid,includingvat) VALUES($1,$2,$3,$4,$5,$6,$7) returning proopid'
        optionJson.forEach(async (element, index) => {                                                         
        const valueProductoption = [active, date, optionJson[index].sku, optionJson[index].price, optionJson[index].optionvalue, product.rows[0].proid, optionJson[index].vat]
        const productoption = await db.query(sqlProductoption, valueProductoption);
        const valueEventDetail = [eventproduct.rows[0].eventid, productoption.rows[0].proopid];
        await db.query(sqlEventDetail, valueEventDetail);
        const shipping = await db.query(sqlShipping, valueShipping);
        const payment = await db.query(sqlPayment, valuePayment);
        const valueOrderProduct = [active, decode.data.id, payment.rows[0].payid, shipping.rows[0].shipid, eventproduct.rows[0].eventid]; 
        const orderproduct = await db.query(sqlOrderProduct, valueOrderProduct);
        productoption.rows.map(index => {
            const valueOrderDetail = [active, amount, address, phonenumber, orderproduct.rows[0].orderid, index.proopid]; 
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

async function lists(req, res, next) {
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const sql = `select 
    product.photo, product.proname, product.category,
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

async function getproduct(req, res) {
    const detail = []
    const getPopup = `select 
    product.proid,product.photo,product.proname, product.prodetail, product.category,
    productoption.proopid,productoption.price,productoption.sku,productoption.includingvat ,productoption.optionvalue,productoption.totalproduct,
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
                'vat': rows[i].includingvat,
                'totalproduct': rows[i].totalproduct
            }
            detail.push(obj)
        }
        const tranfrom = {
            proid: rows[0].proid,
            category: rows[0].category,
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
    const days = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const dates = date +' '+ time;
    const ends = moment(dates).format('YYYY-MM-DD HH:mm:ss');
    const end = moment(ends).add(hour, 'h');
    const types = 'preorder';
    try {
        const sqlProduct = `select * from product where proid = $1`;
        const valueProduct = [productid];
        const { rows } = await db.query(sqlProduct, valueProduct);
        const sql = `insert into product (active, proname, prodetail, photo, sellerid, timestart, timeend, category) values ($1, $2, $3, $4, $5, $6, $7, $8) returning proid`;
        const value = [active,rows[0].proname, rows[0].prodetail, rows[0].photo, rows[0].sellerid, ends, new Date(end.toString()), rows[0].category];
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

async function edit (req, res, next) { 
    const { proid, proname, prodetail, category} = req.body;
    const options= JSON.parse(req.body.option)
    let data = req.files.map( (item, index) =>  item.filename );
    const sqlproduct = `update product set proname = $1, prodetail = $2, category = $3, photo = $4 where proid = $5`
    const valueproduct = [proname, prodetail, category, data, proid]
    const sqlproductoption = `update productoption set price = $1 where proopid = $2`
    const sqlproducts = `update product set proname = $1, prodetail = $2, category = $3 where proid = $4`
    const valueproducts = [proname, prodetail, category, proid]
    try {
        if (data[0] === undefined) {
            await db.query(sqlproducts, valueproducts);
            options.forEach(async(element, index) => {
                const valueproductoption = [options[index].price, options[index].proopid]
                await db.query(sqlproductoption, valueproductoption);
            })
        } else {
            await db.query(sqlproduct, valueproduct);
            options.forEach(async(element, index) => {
                const valueproductoption = [options[index].price, options[index].proopid]
                await db.query(sqlproductoption, valueproductoption);
            })
        }
        return Responce.resSuccess(res, successMessage.success);        
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    }
}

async function search (req, res, next) {
    const { proname } = req.body;
    const search = '%'+proname+ '%'
    const sql = `select 
    proid, proname, prodetail, photo, sellerid, timestart, timeend, category 
    from product 
    where proname like $1 `;
    const value = [ search ]
    let products = [];
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    try {
        const product = await db.query(sql, value);
        await Promise.all(product.rows.map(async(item) => {
        const option = await productoptions.option(item.proid);
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
                category: item.category,
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

module.exports = {
    list,
    orderlists,
    homepage,
    addhomepage,
    lists,
    getproduct,
    orderadd,
    edit,
    search,
}
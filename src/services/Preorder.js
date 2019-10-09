const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment');

async function getProduct (req, res) {
    const sql = `select 
    product.proid, product.proname, product.category
    from productoption
    full join product on product.proid = productoption.proid
    where 
    sellerid = $1 and productoption.types ='order' group by product.proid`
    let responce = []
    try {
        const value = await db.query(sql, [req.params.id]);
        for ( let i = 0; i < (value.rows).length; i++) {
            let data = {
                order : i+1,
                productid : value.rows[i].proid,
                productname : value.rows[i].proname,
                category: value.rows[i].category
            }
            responce.push(data)
        }
        return Responce.resSuccess(res,successMessage.success, responce);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function getProductPreorder (req,res, next) {
    const sql = `select 
    proid,proname,prodetail,photo,sellerid,timestart,timeend 
    from product 
    where sellerid = $1`;
    let products = [];
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    try {
        const product = await db.query(sql, [req.params.id]);
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
                'status':'on preorder',
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
        } else {
            let obj = {
                'status':'time out',
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

async function getProductDetail (req, res) {
    const key = req.params.id
    const selectOne =   `select 
                proopid,sku,price,optionvalue 
                from productoption
                WHERE proid = $1`
    try { 
        const result = await db.query(selectOne,[key])
        return Responce.resSuccess(res, successMessage.success, result.rows);
    } catch (error) {   
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

async function insertPreorder (req, res) {
    const active = true
    const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    const {dStart, dEnd, option} = req.body
    const queryEvent = 'INSERT INTO eventproduct(active,datemodify,timestart,timeend,countdowntime) VALUES($1,$2,$3,$4,$5) returning eventid'
    const queryEventDetail = 'INSERT INTO eventdetail(totalproduct,eventid,proopid) VALUES($1,$2,$3)'
    try {
        let a = moment(dEnd)
        let b = moment(dStart)
        let countdown = a.diff(b)
        const valueEvent = [active, today, dStart, dEnd, countdown]
        await db.query('BEGIN');
        const result = await db.query(queryEvent, valueEvent)
        for (let i = 0; i < (option).length; i++) {
            const valueEventDetail = [option[i].amount, result.rows[0].eventid, option[i].id]
            await db.query(queryEventDetail, valueEventDetail)
        }
        await db.query('COMMIT');
        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}

module.exports = {
    getProduct,
    getProductPreorder,
    getProductDetail,
    insertPreorder
}

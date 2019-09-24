const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment');

    async function getProduct (req, res) {
        const sql = `select 
        product.proid, product.proname
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
                    productname : value.rows[i].proname
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
        const sql = `select proid,proname,prodetail,photo,sellerid from product where sellerid = $1`;
        let responce = [];
        const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    try {
        const product = await db.query(sql, [req.params.id]);
        await Promise.all(product.rows.map(async(item) => {
        const option = await getOption(item.proid);
        if (option[0] !== undefined) {
            let obj = {
                proid: item.proid,
                photo: item.photo,
                sellerid: item.sellerid,
                proname: item.proname,
                prodetail: item.prodetail,
                timestart: moment(option[0].timestart).format('YYYY-MM-DD HH:mm:ss'),
                timeend: moment(option[0].timeend).format('YYYY-MM-DD HH:mm:ss'),
                hour: moment(option[0].timeend).format('HH'),
                time: moment(option[0].timeend).format('HH:mm:ss'),
                result: option
            }
            responce.push(obj);
            }
        }));
        return Responce.resSuccess(res, successMessage.success,responce);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
async function getOption (productid) {
    const sql = `select 
    productoption.proopid,productoption.sku,productoption.price,productoption.includingvat,productoption.optionvalue,
    eventproduct.timestart, eventproduct.timeend,
    eventdetail.totalproduct
    from productoption
    full join eventdetail on eventdetail.proopid = productoption.proopid
    full join  eventproduct on  eventproduct.eventid = eventdetail.eventid
    where proid = $1 and types = 'preorder'`
    return new Promise(async(resolve , reject) => {
        try {
            const { rows } = await db.query(sql, [productid]);
            rows.map(index => {
                index.timeend = moment(index.timeend).subtract(7, 'h');
                index.timeend = moment(index.timeend).format('YYYY-MM-DD HH:mm:ss');
                index.timestart = moment(index.timestart).format('YYYY-MM-DD HH:mm:ss');                    
                const addTime = index.timeend = moment(index.timeend).add(7, 'h');
                const endTime = index.timeend = moment(addTime).format('YYYY-MM-DD HH:mm:ss');
                const startTime = index.timestart = moment(index.timestart).format('YYYY-MM-DD HH:mm:ss');
                if (endTime > date && date > startTime) {
                    products.push(index);
                } else {
                    delete index;
                }
            });
            resolve(products);
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

const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment');

const Preorder = {
    async getProduct (req, res) {
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
    },
    async getProductPreorder (req,res, next) {
        // product.proname, product.prodetail,product.photo
        const sql = `select
        product.proid,product.proname, product.photo,
        productoption.sku, productoption.price, productoption.includingvat,productoption.optionvalue,
        eventproduct.timestart,eventproduct.timeend,
        eventdetail.totalproduct
        from productoption
        inner join product on product.proid = productoption.proid
        inner join eventdetail on eventdetail.proopid = productoption.proopid
        inner join eventproduct on eventproduct.eventid = eventdetail.eventid
        where productoption.types ='preorder' and product.sellerid = $1 order by product.proid`
        const detail = [];
        const status = '';
        const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        try {
            const value = await db.query(sql, [req.params.id]);
            // index.timeend = moment(index.timeend).format('YYYY-MM-DD HH:mm:ss');
            console.log(value.rows);
            value.rows.map(async(element, index)=> {
                
                let data = {
                    proname: value.rows[index].proname,
                    datestart: moment(value.rows[index].timestart).format('YYYY-MM-DD HH:mm:ss'),
                    dateend: moment(value.rows[index].timeend).format('YYYY-MM-DD HH:mm:ss'),
                    hour: moment(value.rows[index].timeend).format('HH'),
                    time: moment(value.rows[index].timeend).format('HH:mm:ss'),
                    sku: value.rows[index].sku,
                    amount: value.rows[index].totalproduct,
                    vat: value.rows[index].includingvat,
                    price: value.rows[index].price,
                    optionvalue: value.rows[index].optionvalue
                }
                detail.push(data);
                return value.rows[index].sku;
            });
            console.log(value.rowCount);
            return Responce.resSuccess(res,successMessage.success, detail);
        } catch (error) {
            throw error
            // return Responce.resError(res, errorMessage.saveError);
        } finally {
            res.end();
        }
    },
    async getProductDetail (req, res) {
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
    },
    async insertPreorder (req, res) {
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
}

module.exports = {Preorder}

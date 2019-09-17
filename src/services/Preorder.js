const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const moment = require('moment');

const Preorder = {
    async getProduct (req, res) {
        const selectAll = 'SELECT proid,proname FROM product WHERE sellerid = $1'
        let resp = []
        try {
            const value = await db.query(selectAll,[req.params.id])
            for ( let i = 0; i < (value.rows).length; i++) {
                let obj = {
                    order : i+1,
                    productid : value.rows[i].proid,
                    productname : value.rows[i].proname
                }
                resp.push(obj)
            }
            return Responce.resSuccess(res, successMessage.success, resp);
        } catch (error) {
            return Responce.resError(res, errorMessage.saveError);
        } finally {
            res.end();
        }
    },
    async getProductDetail (req, res) {
        const key = req.params.id
        const selectOne =   `SELECT 
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

const con = require('../configdb/config')
const moment = require('moment')

const Preorder = {
    async getProduct (req, res) {
        const selectAll = 'SELECT proid,proname FROM product WHERE sellerid = $1'
        let resp = []
        try {
            const value = await con.pool.query(selectAll,[req.params.id])
            for ( let i = 0; i < (value.rows).length; i++) {
                let obj = {
                    order : i+1,
                    productid : value.rows[i].proid,
                    productname : value.rows[i].proname
                }
                resp.push(obj)
            }
            const results = {
                status : "200",
                message : "seccess",
                result : resp
            }
            return res.status(200).send(results)
        } catch (error) {
            const results = {
                status : "400",
                message : "error"
            }
            return res.status(400).send(results)
            console.log(error)
        }
    },
    async getProductDetail (req, res) {
        const key = req.params.id
        const selectOne =   `SELECT proopid,sku,price,optionvalue from productoption
                            WHERE proid = $1`
        try { 
            const result = await con.pool.query(selectOne,[key])
            const resp = {
                status : "200",
                message : "seccess",
                result : result.rows
            }
            return res.status(200).send(resp)
        } catch (error) {   
            const resp = {
                status : "200",
                message : "seccess",
                result : resp
            }
            return res.status(200).send(resp)
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
            await con.pool.query('BEGIN')
            const result = await con.pool.query(queryEvent, valueEvent)
            for (let i = 0; i < (option).length; i++) {
                const valueEventDetail = [option[i].amount, result.rows[0].eventid, option[i].id]
                await con.pool.query(queryEventDetail, valueEventDetail)
            }
            await con.pool.query('COMMIT')
            return res.status(200).send({'message':'insert success'});
        } catch (error) {
            console.log(error)
        }
    },
    async getMaxMin(req, res) {
        try {
         const selectMin =   `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MIN (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
             const selectMax =  `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MAX (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
            const selectProduct = 'select proid,proname from product WHERE sellerid = $1' 
            const result = await con.pool.query(selectProduct,[req.params.id]) 
            let sumValue = []
            let price,allValue
            // for (let i = 0; i < (result.rows).length; i++) {
            //     const id = result.rows[i].proid
            //     const queryMax = await con.pool.query(selectMax,[id])
            //     const queryMin = await con.pool.query(selectMin,[id])
            //     const max = queryMax.rows[i].price
            //     const min = queryMin.rows[i].price
            //     const proName = result.rows[i].proname
            //     price = min + ' - ' + max
            //     allValue = {
            //         order : i+1,
            //         proid : id,
            //         proname : proName,
            //         price : price
            //     }
            //     sumValue.push(allValue)
            //     console.log(queryMin)
            // }
            return res.status(200).send('false')
        } catch (error) {
            console.log(error)
        }
    }
}

module.exports = {Preorder}

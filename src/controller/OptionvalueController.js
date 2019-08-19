const con = require('../config/config')
const Helper = require('./Helper')
//MOMENT TIME
const moment = require('moment')
const img = require('./ImageController')
//IMAGE
const multer = require('multer')
const path = require('path')
//INSERT ASYNC
const optionValue = {
    async insert (req,res){
        const {picture,productname,detail,option,sellerid} = req.body
        const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        const active = true
        const insertProduct = 'INSERT INTO product(active,datemodify,proname,prodetail,photo,sellerid) VALUES($1,$2,$3,$4,$5,$6) returning proid'
        const valueProduct = [active, today, productname, detail, picture, sellerid]
        try{
            con.pool.query('BEGIN')
            const returnProduct = await con.pool.query(insertProduct,valueProduct)
            const insertPOp = 'INSERT INTO productoption(active,datemodify,sku,price,optionvalue,proid) VALUES($1,$2,$3,$4,$5,$6)'
            for (let i = 0 ; i < option.length; i++) {
                const valuePOp = [active, today, option[i].sku, option[i].price, option[i].optionvalue, returnProduct.rows[0].proid]
                await con.pool.query(insertPOp, valuePOp)
                console.log(valuePOp)
            }
            con.pool.query('COMMIT')
            return res.status(200).send({'message':'success'});
        }catch(error){
            console.log(error)
        }
    }
}

module.exports = { optionValue}

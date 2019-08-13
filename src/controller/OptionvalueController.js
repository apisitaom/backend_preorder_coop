const con = require('../config/config')
const Helper = require('./Helper')
//MOMENT TIME
const moment = require('moment')

const optionValue = {
    async get (req, res) {
        const getProduct = `SELECT * FROM product WHERE `
        try {
            
        } catch (error) {
            throw error
        }
    },
    
async insert (req,res){
    const a = req.body.option
    const {picture,productname,detail,option,sellerid} = req.body
    const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const active = true
    const insertProduct = 'INSERT INTO product(active,datemodify,proname,prodetail,photo,sellerid) VALUES($1,$2,$3,$4,$5,$6) returning proid'
    const valueProduct = [active, today, productname, detail, picture, sellerid]
    try{
        con.pool.query('BEGIN')
        const returnProduct = await con.pool.query(insertProduct,valueProduct)
        console.log(`insert Product`)
        for (let i = 0 ; i < option.length; i++) {
            const insertPOp = 'INSERT INTO productoption(active,datemodify,picture,sku,price,proid) VALUES($1,$2,$3,$4,$5,$6) returning proopid'
            const valuePOp = [active, today, picture, option[i].sku, option[i].price, returnProduct.rows[0].proid]
            const returnPOp = await con.pool.query(insertPOp, valuePOp)
            console.log(`insert Product Option : ${i}`)
            const insertOpValue = 'INSERT INTO optionvalue(active,datemodify,optionvaluename,optionvalue,proopid) VALUES($1,$2,$3,$4,$5)'
            const valueOpValue = [active, today, option[i].optionname, option[i].optionvalue, returnPOp.rows[0].proopid]
            await con.pool.query(insertOpValue, valueOpValue)
            console.log(`insert Option Value : ${i}`)
        }
        con.pool.query('COMMIT')
        return res.status(200).send({'message':'success'});
    }catch(error){
        throw error
    }
  }
}

exports.optionValue = optionValue
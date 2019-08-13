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
            const insertPOp = 'INSERT INTO productoption(active,datemodify,picture,sku,price,proid) VALUES($1,$2,$3,$4,$5,$6) returning proopid'
            const insertOpValue = 'INSERT INTO optionvalue(active,datemodify,optionvaluename,optionvalue,proopid) VALUES($1,$2,$3,$4,$5)'
            // for( let value of option) { 
            //     value.picture
            // }
            for (let i = 0 ; i < option.length; i++) {
                const valuePOp = [active, today, picture, option[i].sku, option[i].price, returnProduct.rows[0].proid]
                const returnPOp = await con.pool.query(insertPOp, valuePOp)
                const valueOpValue = [active, today, option[i].optionname, option[i].optionvalue, returnPOp.rows[0].proopid]
                await con.pool.query(insertOpValue, valueOpValue)
            }
            con.pool.query('COMMIT')
            return res.status(200).send({'message':'success'});
        }catch(error){
            throw error
        }
    }
}
const storage = multer.diskStorage({
    destination:('./public/uploads/'),

    filename: async function (req,file, cb){
        cb(null,file.fieldname +'-'+new Date().getTime().toString()+path.extname(file.originalname))  
        // const {productname="3",detail="4",sku="5",optionname=["2"],optionvalue=["1"],price=25.0,sellerid=1}=req.body
        const {productname,detail,sku,optionname,optionvalue,price,sellerid}=req.body

        const text = file.fieldname +'-'+new Date().getTime().toString()+path.extname(file.originalname)

        const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');

        const create = `with ins1 as (
            insert into product (createdate,photo,proname,prodetail,sellerid) values ($1,$2,$3,$4,$5) returning proid
        )
        ,ins2 as (
            insert into productoption (createdate,sku,price,proid) select $6,$7,$8,proid from ins1 returning proopid
        )
            insert into optionvalue (createdate,optionvaluename,optionvalue,proopid) select $9 , $10,$11 ,proopid from ins2;
        `;
        const value = [date,text,productname,detail,sellerid, date,sku,price,date,optionvalue,optionname];

        // if(productname || detail || sku || optionname || optionvalue || price || sellerid  === null){
        //     return send({'message':'some values has null'});
        // }
        // try{
        con.pool.query(create,value)
        // }catch(error){
        //     return send({'message':'error '});
        // }
    }
})

const upload= multer({
    storage : storage,
    limits:{fileSize: 1000000}
}).array('picture')

module.exports = { upload, optionValue}

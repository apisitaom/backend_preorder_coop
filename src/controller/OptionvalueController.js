const con = require('../config/config')
const Helper = require('./Helper')
//MOMENT TIME
const moment = require('moment')

const optionValue = {
    
async insert (req,res){
    //product
    // proid|createdate|active|datemodify|proname|prodetail|photo|sellerid 
     // productoption
    // proopid | createdate|active|datemodify|sku|price|proid 
    // optionvalue
    // optionvalueid | createdate | active | datemodify | optionvaluename | optionvalue | proopid 
    const {productname,detail,sku,optionname,optionvalue,pice,sellerid}=req.body
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');

    const product = `INSERT INTO product (createdate,proname,prodetail,photo,sellerid) VALUES ($1,$2,$3,$4,$5) returnning proid`;
    const valueproduct = [];

    const productoptions = `INSERT INTO productoption (createdate,sku,price,proid) VALUES ($1,$2,$3,$4) returnning proopid`;
    const valuepro = [date,sku,pice,proid];

    const optionvalues = `INSERT INTO optionvalue (createdate,optionvaluename,optionvalue,proopid) VALUES ($1,$2,$3,$4)`;
    const valueop = [date,optionname,optionvalue,proopid];

    try{
        //OPTION VALUE
        await con.pool.query(optionvalues,valueop);
        //PRODUCT OPTION
        await con.pool.query(productoptions,valuepro);
        //PRODUCT
        await con.pool.query(product,valueproduct);
        console.log(req.body);
        return res.status(200).send({'message':'success'});
    }catch(error){
        return res.status(400).send({'message':'error'});
    }
  }
}

exports.optionValue = optionValue
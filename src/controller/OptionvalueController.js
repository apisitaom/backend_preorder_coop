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
    
    const {picture,productname,detail,sku,optionname,optionvalue,price,sellerid}=req.body
    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');

    const create = `with ins1 as (
        insert into product (createdate,photo,proname,prodetail,sellerid) values ($1,$2,$3,$4,$5) returning proid
    )
    ,ins2 as (
        insert into productoption (createdate,sku,price,proid) select $6,$7,$8,proid from ins1 returning proopid
    )
        insert into optionvalue (createdate,optionvaluename,optionvalue,proopid) select $9 , $10,$11 ,proopid from ins2;
    `;
    const value = [date,picture,productname,detail,sellerid, date,sku,price,date,optionvalue,optionname];
 
    try{
        //PRODUCT || PRODUCT OPTION || OPTION VALUE 
        await con.pool.query(create,value);
        console.log(req.body);
        return res.status(200).send({'message':'success'});
    }catch(error){
        // return res.status(400).send({'message':'error'});
        throw error
    }
  }
}

exports.optionValue = optionValue
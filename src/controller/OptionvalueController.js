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
        insert into product (photo,proname,prodetail,sellerid) values ($1,$2,$3,$4) returning proid
    )
    ,ins2 as (
        insert into productoption (sku,price,proid) select $5,$6,proid from ins1 returning proopid
    )
        insert into optionvalue (optionvaluename,optionvalue,proopid) select $7 , $8 ,proopid from ins2;
    `;
    const value = [picture,productname,detail,sellerid,sku,price,optionvalue,optionname];

    try{
        //PRODUCT || PRODUCT OPTION || OPTION VALUE 
        await con.pool.query(create,value);
        console.log(req.body);
        return res.status(200).send({'message':'success'});
    }catch(error){
        // return res.status(400).send({'message':'error'});
        throw error
    }
  },

  async inserta (req,res){
      
    const create = ` with ins1 as (
        insert into a (name) values ('apisit')
        returning ida 
    )
    ,ins2 as (
        insert into b (name,ida) select 'prompha', ida from ins1
        returning idb 
    )
    insert into c (name,idb) select 'ok',idb from ins2;
    `;
    try{

    }catch(error){

    }
  }
}

exports.optionValue = optionValue
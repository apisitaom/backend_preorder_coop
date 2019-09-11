const db = require('../configdb/configDB');
const moment = require('moment');
const Responce = require('../lib/Reposnce');
const successMessage = require('../lib/successMessage');
const errorMessage = require('../lib/errorMessage');

const optionValue = {
    async insert (req,res){
        console.log(req.body);
        const {picture,productname,detail,sellerid} = req.body
        const optionJson = JSON.parse(req.body.option)
        const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        const active = true;
        const insertProduct = 'INSERT INTO product(active,datemodify,proname,prodetail,photo,sellerid) VALUES($1,$2,$3,$4,$5,$6) returning proid'
        const valueProduct = [active, today, productname, detail, req.files[0].filename, sellerid]
        try{
            db.query('BEGIN')
            const returnProduct = await db.query(insertProduct,valueProduct)
            const insertPOp = 'INSERT INTO productoption(active,datemodify,sku,price,optionvalue,proid,includingvat) VALUES($1,$2,$3,$4,$5,$6,$7)'
            optionJson.forEach(async (element, index) => {
                const valuePOp = [active, today, optionJson[index].sku, optionJson[index].price, optionJson[index].optionvalue, returnProduct.rows[0].proid,optionJson[index].vat]
                await db.query(insertPOp, valuePOp)
            });
            await db.query('COMMIT')
                return Responce.resSuccess(res, successMessage.success);
        }catch(error){
            await db.query('REVOKE');
                return Responce.resError(res, errorMessage.saveError);
        } finally {
            res.end();
        }
    }
}

module.exports = { optionValue}

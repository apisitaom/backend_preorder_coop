const db = require('../configdb/configDB');
const moment = require('moment');
const Responce = require('../lib/Reposnce');
const successMessage = require('../lib/successMessage');
const errorMessage = require('../lib/errorMessage');

async function add (req,res){    
    const { productname, detail, sellerid, category } = req.body
    const optionJson = JSON.parse(req.body.option)
    const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const active = true;
    const types = 'order';
    let data = req.files.map( (item, index) =>  item.filename );
    const picture = [];
    picture.push(data);
    db.query('BEGIN');
    const insertProduct = 'INSERT INTO product(active,datemodify,proname,prodetail,photo,sellerid, category) VALUES($1,$2,$3,$4,$5,$6, $7) returning proid'
    const valueProduct = [active, today, productname, detail, data, sellerid, category];
        const returnProduct = await db.query(insertProduct,valueProduct);
        const insertPOp = 'INSERT INTO productoption(active,datemodify,sku,price,optionvalue,proid,includingvat, types) VALUES($1,$2,$3,$4,$5,$6,$7,$8) returning proopid'
        optionJson.forEach(async (element, index) => {
                const sql = `select sku from productoption where sku = $1`;
                const { rows } = await db.query(sql, [optionJson[index].sku]);
                if (!rows[0]) {
                    const valuePOp = [active, today, optionJson[index].sku, optionJson[index].price, optionJson[index].optionvalue, returnProduct.rows[0].proid,optionJson[index].vat, types]
                    await db.query(insertPOp, valuePOp);
                    db.query('COMMIT');
                    return Responce.resSuccess(res, successMessage.success);
                } if (rows[0]) {
                    db.query('REVOKE');
                    return Responce.resError(res, errorMessage.sku);
                }
        });
}

module.exports = {
    add
}

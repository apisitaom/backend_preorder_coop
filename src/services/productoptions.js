const db = require('../configdb/configDB');
const moment = require('moment');

async function Productoption (productoptionid, amounts) {
    const sql = `select productoption.proopid, productoption.price, productoption.includingvat,
    productoption.optionvalue, productoption.totalproduct,
    productoption.sku, 
    product.proid, product.proname, product.prodetail, product.photo, product.sellerid,
    product.timestart, product.timeend
    from productoption
    full join product on product.proid = productoption.proid
    where productoption.proopid = $1`
    return new Promise (async(resolve, reject) => {
            let data = await Promise.all(productoptionid.map(async(index) => {
                for (let i = 0; i< amounts.length;i++) {
                const { rows } = await db.query(sql, [index]);
                    rows[0].timeend = moment(rows[0].timeend).subtract(7, 'h');
                    rows[0].timeend = moment(rows[0].timeend).format('YYYY-MM-DD HH:mm:ss');
                    rows[0].timestart = moment(rows[0].timestart).format('YYYY-MM-DD HH:mm:ss');                  
                    let responce = {
                            proopid: rows[0].proopid,
                            price: rows[0].price,
                              includingvat: rows[0].includingvat,
                            optionvalue: rows[0].optionvalue,
                            totalproduct: rows[0].totalproduct,
                            sku: rows[0].sku,
                            proid: rows[0].proid,
                            proname: rows[0].proname,
                            prodetail: rows[0].prodetail,
                            photo: rows[0].photo,
                            sellerid: rows[0].sellerid,
                            timestart: rows[0].timestart,
                            timeend: rows[0].timeend,
                            amounts: amounts[i]
                        }
                    return responce;
                }
                
            }));
            resolve(data);
    });
}

module.exports = {
    Productoption
}
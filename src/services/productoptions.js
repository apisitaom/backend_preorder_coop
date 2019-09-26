const db = require('../configdb/configDB');
const moment = require('moment');

async function Productoption (productoptionid) {
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
            const {rows} = await db.query(sql, [index]);
            rows[0].timeend = moment(rows[0].timeend).subtract(7, 'h');
            rows[0].timeend = moment(rows[0].timeend).format('YYYY-MM-DD HH:mm:ss');
            rows[0].timestart = moment(rows[0].timestart).format('YYYY-MM-DD HH:mm:ss');                    
            return rows
        }));
        resolve(data);
    });
}

module.exports = {
    Productoption
}
const db = require('../configdb/configDB');
const errorMessage = require('../lib/errorMessage');
const successMessage = require('../lib/successMessage');
const Responce = require('../lib/Reposnce');
const helper = require('../lib/Helper');

const Product = {
    async getPopup(req, res) {
        console.log(req.params);
        console.log(req.body);
        const getPopup = `select product.photo,product.proname,productoption.price,productoption.optionvalue
        from product inner join productoption on product.proid = productoption.proid where product.proid = $1`;
        try {
            const { rows } = await db.query(getPopup, [req.params.id]);
            return Responce.resSuccess(res, successMessage.success, rows);
        } catch (error) {
            return Responce.resError(res, errorMessage.saveError);
        }
    },
    async getMaxMin(req, res) {
        try {
            const selectMin = `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MIN (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
            const selectMax = `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MAX (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
            const selectProduct = 'select proid,proname from product'
            const result = await db.query(selectProduct)
            let sumValue = []
            let price, allValue
            for (let i = 0; i < (result.rows).length; i++) {
                const id = result.rows[i].proid
                const queryMax = await db.query(selectMax, [id])
                const queryMin = await db.query(selectMin, [id])
                const max = queryMax.rows[i].price
                const min = queryMin.rows[i].price
                const proName = result.rows[i].proname
                price = min + ' - ' + max
                allValue = {
                    order: i + 1,
                    proid: id,
                    proname: proName,
                    price: price
                }
                sumValue.push(allValue)
            }
            return Responce(res, successMessage.success, sumValue);
        } catch (error) {
            return  Responce.resError(res, errorMessage.saveError);
        }
    }
}

async function homepageCustomer(req, res, next) {
    const sql = `select product.proname, product.photo, eventproduct.timestart,
    eventproduct.timeend, eventproduct.countdowntime, productoption.proopid,
    productoption.optionvalue,  productoption.price, seller.sellername from productoption 
    full join product on product.proid = productoption.proid 
    full join eventdetail on eventdetail.eventid = productoption.proid
    full join eventproduct on eventproduct.eventid = eventdetail.eventid
    full join seller on seller.sellerid = product.sellerid;
    `
    try {
        const { rows } = await db.query(sql);
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError, );
    } finally {
        res.end();
    }
}

async function insertProductHomepage (req, res, next) {
    
    const {amount, userid, proopid} = req.body
    //  JWT
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    const value = [decode.data.id];

    const active = true;
    
    // ORDER PRODUCT
    const sqlOrderProduct = `insert into orderproduct (active, userid) values ($1, $2) returning orderid`
    const valuesOrderProduct = [  active , userid];
    
    const sqlOrderDetail = `insert into orderdetail (active, amount, proopid, orderid) values ($1, $2, $3, $4)`

    try {

        await db.query('BEGIN');

        // ORDER PRODUCT
        const orderproduct = await db.query(sqlOrderProduct, valuesOrderProduct);
    
        // ORDER DETAIL
        const valuesOrderDetail = [ active, amount, proopid, orderproduct.rows[0].orderid];
        await db.query(sqlOrderDetail, valuesOrderDetail);
        
        await db.query('COMMIT');

        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        // throw error
        await db.query('REVOKE');
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        res.end();
    }
}
// cart-customer
async function getCartCustomer(req, res, next) {
    const sql = ``
    const value = []
    try {
        const { rows } = await db.query(sql);
        await db.query(psql);
        return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error) {
        return Responce.resError(res, errorMessage.saveError);
    } finally {
        // throw error
        res.end();
    }
}
// cart-customer
async function cartCustomer(req, res, next) {
    const { productname, address, phonenumber, countdowntime } = req.body
    const optionJson = JSON.parse(req.body.option)

    const date = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const active = true;

    const val = `{${req.files.map((item) => item.filename).join()}}`
    const pictures = []
    pictures.push(val);

    // MEMBER
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);
    // PRODUCT 
    const sqlProduct = ``
    const valueProduct = [];
    // EVENT PRODUCT
    const sqlEventProduct = ``
    const valueEventProduct = [];
    // PRODUCT OPTION
    const insertProductoption = 'INSERT INTO productoption(active,datemodify,sku,price,optionvalue,proid,includingvat) VALUES($1,$2,$3,$4,$5,$6,$7)'
    optionJson.forEach(async (element, index) => {
        const valuePOp = [active, today, optionJson[index].sku, optionJson[index].price, optionJson[index].optionvalue, returnProduct.rows[0].proid,optionJson[index].vat]
        await db.query(insertProductoption, valuePOp);
    });
    //EVENT DETIAL
    const sqlEventDetail = ``
    const valueEventDetail = [];
    // SHIPPING  
    const shipstatusid = '322cbbd2-2676-42a1-babc-3a976a3439bd'; // กำลังส่งรายการการสั่งซื้อไปที่ผู้ขาย
    const sqlShipping = ``
    const valueShipping = [];
    // PAYMENT  
    const paystatusid = '28e98270-c833-4f9d-a4ec-f5c1ca127a5e'; // ต้องชำระ
    const sqlPayment = ``
    const valuePayment = [];
    // EVENT PRODUCT 
    const sqlEventProduct = ``
    const valueEventProduct = [];
    try{

        return Responce.resSuccess(res, successMessage.success);
    } catch (error) {
        throw error
    } finally {
        res.end();
    }
}

async function shopCustomer(req, res, next) {
    
    const { headers } = req;
    const subtoken = headers.authorization.split(' ');
    const token = subtoken[1];
    const decode = helper.Helper.verifyToken(token);

    const sql = `select product.photo, product.proname, seller.address, seller.subdistrict, seller.district, seller.zipcode, seller.province,
    seller.phonenumber, seller.email, seller.photo, eventproduct.timestart, eventproduct.timeend, eventproduct.timeend,
    productoption.sku, productoption.price, productoption.includingvat, productoption.optionvalue  from product full join seller on seller.sellerid = product.sellerid
    full join productoption on productoption.proid = product.proid full join eventdetail on eventdetail.proopid = productoption.proid 
    full join eventproduct on eventproduct.eventid = eventdetail.eventid where seller.sellerid = $1`
    const value = [decode.data]
    try {
      const { rows } = await db.query(sql, value);

      return Responce.resSuccess(res, successMessage.success, rows);
    } catch (error){
    //   throw error
      return Response.resSuccess(res, successMessage.success);
    } finally {

    }
  }
//   productDetail-customer
  async function getProduct (req, res, next) {
      const {id} = req.params
      const sql = `select product.proname, product.photo, eventproduct.timestart, eventproduct.timeend, eventproduct.countdowntime, productoption.sku, productoption.price, productoption.includingvat, productoption.optionvalue from product full join productoption on productoption.proid = product.proid
      full join eventdetail on eventdetail.proopid = productoption.proid full join eventproduct on eventproduct.eventid = eventdetail.eventid where product.active = true and product.proid = $1`
      const value = [id];

      try {

        const { rows } = await db.query(sql, value);
        return Responce.resSuccess(res, successMessage.success, rows);
      } catch (error) {
        // throw error
        return Responce.resError(res, errorMessage.saveError);
      } finally {
        res.end();
      }

  }

module.exports = {
    Product,
    getCartCustomer,
    homepageCustomer,
    insertProductHomepage,
    shopCustomer,
    getProduct
}


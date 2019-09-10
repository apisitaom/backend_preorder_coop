const db = require('../configdb/configDB');
//MOMENT TIME
const moment = require('moment')
//INSERT ASYNC
const optionValue = {
    async insert (req,res){
        console.log(req);
        console.log('*(&@Y$&*!@Y$Y!@(*$*!@(*')
        console.log(req.body)
        console.log('*(&@Y$&*!@Y$Y!@(*$*!@(*')
        const {productname,detail,option,sellerid, picture} = req.body
        
        // PICTURE
        // const val = `{${req.files.map((item) => item.filename).join()}}`
        // const picture = []
        // picture.push(val)

        const today = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        const active = true
        const insertProduct = 'INSERT INTO product(active,datemodify,proname,prodetail,photo,sellerid) VALUES($1,$2,$3,$4,$5,$6) returning proid'
        const valueProduct = [active, today, productname, detail, picture, sellerid]
        try{
            db.query('BEGIN')

            const returnProduct = await db.query(insertProduct,valueProduct)
            const insertPOp = 'INSERT INTO productoption(active,datemodify,sku,price,optionvalue,proid,includingvat) VALUES($1,$2,$3,$4,$5,$6,$7)'
            // for (let i = 0 ; i < option.length; i++) {
            //     const valuePOp = [active, today, option[i].sku, option[i].price, option[i].optionvalue, returnProduct.rows[0].proid,option[i].vat]
            //     await db.query(insertPOp, valuePOp)
            //     console.log('add product')
            // }
            db.query('COMMIT')
            const response = {
                status : "200",
                message : "success",
                }
            return res.status(200).send(response);
        }catch(error){
            const response = {
                status : "400",
                message : "error",
                }
                return res.status(400).send(response);
        }
        finally{
            throw error
        }
    }
}

module.exports = { optionValue}

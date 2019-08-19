const con = require('../config/config')

const Product = {
    async getPopup(req,res){

        const getPopup = `select product.photo,product.proname,productoption.price,productoption.optionvalue
        from product inner join productoption on product.proid = productoption.proid where product.proid = $1`;
        try{
            const { rows } = await  con.pool.query(getPopup,[req.params.id]);
            console.log('get popup data')
            return res.status(200).send({'message':'get popup success',rows});
        }catch(error){
            return res.status(400).send({'message':'error'});
            }
        },
    async getMaxMin(req, res) {
        try {
         const selectMin =   `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MIN (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
             const selectMax =  `SELECT pro.proid,pro.proname,proop.price 
                                    FROM product pro 
                                    FULL JOIN productoption proop 
                                    ON pro.proid = proop.proid 
                                WHERE price = (
                                    SELECT DISTINCT 
                                    MAX (price) 
                                    FROM productoption 
                                    WHERE proid  = $1)`
            const selectProduct = 'select proid,proname from product' 
            const result = await con.pool.query(selectProduct) 
            let sumValue = []
            let price,allValue
            for (let i = 0; i < (result.rows).length; i++) {
                const id = result.rows[i].proid
                const queryMax = await con.pool.query(selectMax,[id])
                const queryMin = await con.pool.query(selectMin,[id])
                const max = queryMax.rows[i].price
                const min = queryMin.rows[i].price
                const proName = result.rows[i].proname
                price = min + ' - ' + max
                allValue = {
                    order : i+1,
                    proid : id,
                    proname : proName,
                    price : price
                }
                sumValue.push(allValue)
            }
            return res.status(200).send(sumValue)
        } catch (error) {
            console.log(error)
        }
}
}
module.exports = {Product}

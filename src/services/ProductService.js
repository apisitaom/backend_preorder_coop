const con = require('../configdb/config')

const Product = {
    async getPopup(req,res){
        const detail = []
        const getPopup = `select product.photo,product.proname,productoption.price,productoption.optionvalue
        from product inner join productoption on product.proid = productoption.proid where product.proid = $1`;
        try{
            const { rows } = await  con.pool.query(getPopup,[req.params.id]);
            for (let i = 0; i < rows.length; i++) {
                let obj = {'price' : rows[i].price, 'optionvalue' : rows[i].optionvalue}
                detail.push(obj)
            }
            const resp = {
                status : "200",
                message : "get popup sucess",
                photo : rows[0].photo,
                proname : rows[0].proname,
                results : detail
            }
            return res.status(200).send(resp);
        }catch(error){
            const resp = {
                status : "400",
                message : "error"
            }
            return res.status(400).send(resp);
            }
        },
}
module.exports = {Product}

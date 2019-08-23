const con = require('../configdb/config')

const Product = {
    async getPopup(req,res){

        const getPopup = `select product.photo,product.proname,productoption.price,productoption.optionvalue
        from product inner join productoption on product.proid = productoption.proid where product.proid = $1`;
        try{
            const { rows } = await  con.pool.query(getPopup,[req.params.id]);
            return res.status(200).send({'message':'get popup success',rows});
        }catch(error){
            return res.status(400).send({'message':'error'});
            }
        },
}
module.exports = {Product}

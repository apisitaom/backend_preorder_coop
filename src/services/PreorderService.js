const con = require('../configdb/config')

const Preorder = {
    async getProduct (req, res) {
        const selectAll = 'SELECT proid,proname FROM product'
        let resp = []
        try {
            const value = await con.pool.query(selectAll)
            for ( let i = 0; i < (value.rows).length; i++) {
                let obj = {
                    order : i+1,
                    productid : value.rows[i].proid,
                    productname : value.rows[i].proname
                }
                resp.push(obj)
            }
            return res.status(200).send(resp)
        } catch (error) {
            console.log(error)
        }
    },
    async getProductDetail (req, res) {
        const key = req.params.id
        const selectOne =   `SELECT proopid,sku,price,optionvalue from productoption
                            WHERE proid = $1`
        try { 
            const result = await con.pool.query(selectOne,[key])
            return res.status(200).send(result.rows)
        } catch (error) {   
            console.log(error)
        }
    },
    async insertPreorder (req, res) {
        const value = req.body
        try {
            
        } catch (error) {
            console.log(error)
        }
    }
}

module.exports = {Preorder}
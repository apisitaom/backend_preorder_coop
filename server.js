const express = require('express')
const bodyParser = require('body-parser')
const app = express()

//PORT 
const port = 4000

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({extended: true})
)


app.get('/',(req,res) =>{
    res.json({info : `GET START ${port}`})
})

//BODY PATH



app.listen(port,'0.0.0.0',()=>{
    console.log(`Backend running on port ${port}`)
})
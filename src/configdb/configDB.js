const Pool = require('pg').Pool
const pool = new Pool({
  user:process.env.USER || "aom",
  host: process.env.HOST || "localhost",
  database: process.env.DATABASE || "me",
  password: process.env.PASSWORD || "aom",
  port: 5432,
})

module.exports = pool
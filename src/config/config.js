const Pool = require('pg').Pool
const pool = new Pool({
  user: 'aom',
  host: 'localhost',
  database: 'api',
  password: 'aom',
  port: 5432,
})

exports.pool = pool
const { promisify } = require("util")
const { createPool } = require("mysql")

const credenciales = {
  port: process.env.MYSQL_PORT,
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
}

const pool = createPool(credenciales)

pool.queryPromisify = promisify(pool.query)

module.exports = pool
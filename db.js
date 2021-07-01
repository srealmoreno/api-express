const { promisify } = require("util")
const { createPool } = require("mysql")

const credenciales = {
  host: "127.0.0.1",
  user: "express_api",
  password: "express_api",
  database: "express_api"
}

const pool = createPool(credenciales)

pool.queryPromisify = promisify(pool.query)

module.exports = pool
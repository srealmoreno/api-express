const express = require("express")
const database = require("./db.js")
const { urlencoded, json } = express
const app = express()

const IP = "127.0.0.1"
const PORT = 3000

app.use(urlencoded({ extended: false }))
app.use(json())

express.response.sendMessage = function (data = undefined) {
    const body = {
        success: true,
        status: "success"
    }

    if (data !== undefined)
        body["data"] = data

    this.status(200).json(body)
}

express.response.sendError = function (code, message) {
    const body = {
        success: false,
        status: "failed",
        error: {
            code: code,
            message: message
        }
    }

    this.status(code).json(body)
}

express.request.isBodyEmpty = function () {
    return Object.keys(this.body).length === 0
}

const mysqlErrors = {
    ER_NO_DEFAULT_FOR_FIELD: (res, errorMessage) => {
        res.sendError(400, "Bad request, " + errorMessage)
    },

    ER_BAD_FIELD_ERROR: (res, errorMessage) => {
        res.sendError(400, "Bad request, " + errorMessage)
    },

    ER_DUP_ENTRY: (res, errorMessage) => {
        res.sendError(409, "Conflict, " + errorMessage)
    }
}

// Obtener todos los usuarios
app.get("/api/usuarios", async (req, res) => {

    console.log("Obtener todos los usuarios")

    try {
        const usuarios = await database.queryPromisify("SELECT * FROM usuarios")

        if (usuarios.length === 0)
            return res.sendError(404, "Empty list")

        return res.sendMessage(usuarios)

    } catch (error) {
        console.error(error)

        return res.sendError(500, "Internal Server Error, " + error.message)
    }
})

// Obtener usuario por un ID pasado por la URL (req.params)
app.get("/api/usuarios/:id", async (req, res) => {
    console.log("Obtener usuario por id " + req.params.id)

    try {
        const [usuario] = await database.queryPromisify(
            "SELECT * FROM usuarios WHERE id = ?", [req.params.id]
        )

        if (usuario === undefined)
            return res.sendError(404, "Not found")

        return res.sendMessage(usuario)
    } catch (error) {
        console.error(error)

        return res.sendError(500, "Internal Server Error, " + error.message)
    }
})

// Guardar un nuevo usuario (req.body)
app.post("/api/usuarios", async (req, res) => {

    console.log("Guardar un nuevo usuario")

    if (req.isBodyEmpty())
        return res.sendError(400, "Bad request, empty data")

    try {
        await database.queryPromisify("INSERT INTO usuarios SET ?", [req.body])

        return res.sendMessage()
    } catch (error) {
        console.error(error)

        if (mysqlErrors[error.code])
            return mysqlErrors[error.code](res, error.message)
        else
            return res.sendError(500, "Internal Server Error, " + error.message)
    }
})

// Actualizar usuario por un ID pasado por la URL
app.put("/api/usuarios/:id", async (req, res) => {

    console.log("Actualizar usuario por id " + req.params.id)

    if (req.isBodyEmpty())
        return res.sendError(400, "Bad request, empty data")

    try {

        const { affectedRows } = await database.queryPromisify(
            "UPDATE usuarios SET ? WHERE id = ?", [req.body, req.params.id]
        )

        if (affectedRows !== 0)
            return res.sendMessage()
        else
            return res.sendError(404, "Not found")

    } catch (error) {
        console.error(error)

        if (mysqlErrors[error.code])
            return mysqlErrors[error.code](res, error.message)
        else
            return res.sendError(500, "Internal Server Error, " + error.message)
    }
})

// Eliminar un usuario por un ID pasado por la URL (req.params)
app.delete("/api/usuarios/:id", async (req, res) => {

    console.log("Eliminar usuario por id " + req.params.id)

    try {

        const { affectedRows } = await database.queryPromisify(
            "DELETE FROM usuarios WHERE id = ?", [req.params.id]
        )

        if (affectedRows !== 0)
            return res.sendMessage()
        else
            return res.sendError(404, "Not found")

    } catch (error) {
        console.error(error)

        return res.sendError(500, "Internal Server Error, " + error.message)
    }
})

app.listen(PORT, IP, ()=> console.log(`Listening in http://${IP}:${PORT}`))
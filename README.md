![#](https://img.shields.io/badge/%20-api-pink) ![#](https://img.shields.io/badge/%20-Node-grey) ![#](https://img.shields.io/badge/%20-Docker-blue) ![#](https://img.shields.io/badge/%20-Express-green) ![#](https://img.shields.io/badge/%20-Mysql-lightblue) ![#](https://img.shields.io/badge/Tutoriales-Srealmoreno-red?style=flat&logo=github)

# Crear una api utilizando express y mysql sobre docker

En este pequeño tutorial crearemos una api de usuarios utilizando Nodejs con express en **Ubuntu** 20.04 LTS.
Por razones de entendimiento algunas cosas muy puntuales las dejaré en inglés y me limitaré a dar una explicación breve ya que este tutorial se haría muy extenso.

## Indíce

- [Conocimientos preliminares](#conocimientos-preliminares)
- [Requisitos](#requisitos)
- [Dependencias](#dependencias)
  - [Instalación](#instalación-de-dependencias)
  - [Extensiones de vscode](#instalar-extensiones-en-vscode)
- [Iniciando el proyecto](#iniciando-el-proyecto)
- [Añadir variables de entorno](#añadir-variables-de-entorno)
- [Mysql](#mysql)
  - [Crear conexión mysql en vscode](#crear-conexión-mysql-en-vscode)
  - [Crear base de datos](#crear-base-de-datos-y-usuario-en-mysql)
  - [Ejecutar script sql](#ejecutar-script-sql)
  - [Módulo de mysql](#módulo-de-mysql)
- [Index.js](#index.js)
  - [Importación de módulos y declaración de constantes](#1-importación-de-módulos-y-declaración-de-constantes)
  - [Declaración de formato de mensajes de respuesta](#2-declaración-de-formato-de-mensajes-de-respuesta)
  - [Declaración de métodos de comprobación](#3-declaración-de-métodos-de-comprobación)
  - [Manejo de excepciónes de la base de datos](#4-manejo-de-excepciónes-de-la-base-de-datos)
  - [Declaración de métodos HTTP en nuestro servidor](#5-declaración-de-métodos-http-en-nuestro-servidor)
    - [GET](#get)
    - [POST](#post)
    - [PUT](#get)
    - [DELETE](#delete)
  - [Poner en escucha el servidor](#6-poner-en-escucha-el-servidor)
- [Código fuente completo](#código-fuente-completo)
- [Poner en marcha nuestro servidor](#poner-en-marcha-nuestro-servidor)
- [Pruebas](#pruebas)
  - [Crear colección en Thunder Client](#crear-colección-en-thunder-client)
    - [GET](#crear-solicitud-get)
    - [POST](#crear-solicitud-post)
    - [PUT](#crear-solicitud-put)
    - [DELETE](#crear-solicitud-delete)
  - [Colección completa de Thunder Client](#colección-completa-de-thunder-client)
  - [Ejecución](#ejecución-de-pruebas)
    - [POST](#ejecución-solicitud-post)
    - [GET](#ejecución-solicitud-get)
    - [PUT](#ejecución-solicitud-put)
    - [DELETE](#ejecución-solicitud-delete)

---

## Conocimientos preliminares

Necesitamos tener conocimientos acerca de algunos conceptos claves que utilizaremos en este proyecto:

Si tienes conocimientos de estos temas, puedes omitir la lectura.

- [Protocolo HTTP](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#protocolo-http)
- [JavaScript](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#javascript)
- [Mysql](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#mysql)
- [Json](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#json)

Puedes leerlos en la [WIKI](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares) del proyecto

---

## Requisitos

- Distribución Debian, Ubuntu o derivados
- Conocimientos básicos de operaciones CRUD en mysql
- Conocimientos básicos HTTP/1.1
- Conocimientos básicos de JavaScript (EcmaScript 6)
- Visual studio code

---

## Dependencias

1. Git
2. Nodejs
3. npm
4. Docker

---

### Instalación de dependencias

El script se encargara de instalar las dependencias necesarias para el proyecto, en una terminal ejecutar lo siguiente:

```bash
sudo apt install git

git clone https://github.com/srealmoreno/api-express.git

cd api-express

chmod +x build/build.sh

sudo build/build.sh
```

---

### Instalar extensiones en vscode

En visual studio code debes de buscar e instalar las siguientes extensiones

- ms-azuretools.vscode-docker

![Instalar extensión Docker en vscode](assets/install_docker_extension.gif)

- cweijan.vscode-mysql-client2

![Instalar extensión Mysql en vscode](assets/install_mysql_extension.gif)

- rangav.vscode-thunder-client

![Instalar extensión Thunder cliente en vscode](assets/install_thunder_client_extension.gif)

---

Si deseas ahorrarte la creación del código fuente del proyecto, ejecuta esto en la terminal

```bash
git checkout finished

npm install
```

Luego sigue solamente estos pasos:

[Ir a rama finished](https://github.com/srealmoreno/api-express/tree/finished)

- [Crear conexión mysql en vscode](https://github.com/srealmoreno/api-express/tree/finished#crear-conexión-mysql-en-vscode)
- [Ejecutar script sql](https://github.com/srealmoreno/api-express/tree/finished#ejecutar-script-sql)
- [Poner en marcha nuestro servidor](https://github.com/srealmoreno/api-express/tree/finished#poner-en-marcha-nuestro-servidor)
- [Importar Tests Thunder en vscode](https://github.com/srealmoreno/api-express/tree/finished#colección-completa-de-thunder-client) (puedes encontrar el archivo en '**tests/thunder_test.json**')
- [Ejecución de Test](https://github.com/srealmoreno/api-express/tree/finished#ejecución-de-pruebas)

## Iniciando el proyecto

Debemos inicializar un proyecto utilizando npm, instalar dependencias y crear los archivos **db.sql** **db.js** **index.js** **.env**, en la terminal que tenemos abierta ejecutar lo siguiente:

```bash
npm init -y
npm install express mysql dotenv -E
npm install nodemon -E -D
touch db.sql db.js index.js .env
code .
```

Modificar el archivo **package.json**, agregar la linea **"start"** y **"dev"**

```json
"scripts": {
    "start": "node index.js",
    "dev": "nodemon node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
}
```

---

## Añadir variables de entorno

Debemos definir algunas variables de entorno que necesitará nuestro proyecto, agrega el siguiente código en el archivo **.env**

```env
NODE_PORT=3000
NODE_IP=127.0.0.1

MYSQL_PORT=3306
MYSQL_HOST=127.0.0.1
MYSQL_USER=express_api
MYSQL_PASSWORD=express_api
MYSQL_DATABASE=express_api
```

Para poder obtener las variables debemos importar el módulo 'dotenv' en el archivo principal del proyecto (index.js) y accedemos a ellas escribiendo "process.env." antes del nombre de la variable, e.j

```javascript
require('dotenv').config()

const IP = process.env.NODE_IP
const PORT = process.env.NODE_PORT
```

---

## Comprobar conexión con docker

En el apartado de [docker](#instalar-extensiones-en-vscode) (icono de la ballena) debemos de tener un contenedor **mysql:8.0.25 node-mysql-api** como la siguiente imagen

![Comprobar conexión con imagen de docker](assets/check_docker_connection.gif)

---

## Mysql

### Crear conexión mysql en vscode

En el apartado de [EXPLORER:DATABASE](#instalar-extensiones-en-vscode) (icono del barril) debemos de crear una nueva conexión con mysql

![Comprobar conexión con imagen de docker](assets/new_connection_mysql.gif)

Ingresar rellenar con los siguientes campos:

La contraseña es tu nombre de usuario. e.j: mi nombre de usuario es "**srealmoreno**" entonces la contraseña es **srealmoreno**

|                       |             |
| --------------------- | ----------- |
| **Connection Name**   | mysql_root  |
| **Connection Target** | global      |
| **Database Type**     | mysql       |
| **Host**              | 127.0.0.1   |
| **Port**              | 3306        |
| **Username**          | root        |
| **Password**          | tu usuario  |
| **Databases**         |             |
| **Include Databases** |             |
| **ConnectTimeout**    | 5000        |
| **RequestTimeout**    | 10000       |
| **Timezone**          | +00:00      |
| **SSH Tunnel**        | desactivado |
| **Use SSL**           | desactivado |

![Comprobar conexión con imagen de docker](assets/new_connection_mysql_values.png)

---

### Crear base de datos y usuario en mysql

Debemos crear un script sql que contenga las instrucciones para crear nuestra base de datos y nuestro usuario

En este tutorial crearemos una base de datos de usuarios, agrega el siguiente código al archivo **db.sql**

```sql
-- Crear base de datos solo si no existe llamada 'express_api'
CREATE DATABASE IF NOT EXISTS express_api;

-- Usar la base de datos anteriormente creada
USE express_api;

-- Crear tabla si no existe llamada 'usuarios' con los siguientes atributos:
-- 1. 'id' de tipo entero sin signo, que sea una llave primaria   y auto incrementable
-- 2. 'nombre' de tipo varchar con longitud de 30 caracteres   y que no sea NULL
-- 3. 'apellido' de tipo varchar con longitud de 30 caracteres y que no sea NULL
-- 4. 'correo' de tipo varchar con longitud de 40 caracteres
CREATE TABLE IF NOT EXISTS usuarios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    correo VARCHAR(50)
);

-- Crear Usuario si no existe llamado 'express_api' y que
-- sea accesible desde cualquier parte con contraseña nativa 'express_api'
CREATE USER IF NOT EXISTS 'express_api' @'%' IDENTIFIED WITH mysql_native_password BY 'express_api';

-- Otorgarle permisos totales (CREATE, DROP, DELETE, INSERT, SELECT, UPDATE)
-- al usuario 'express_api' sobre la tabla anteriormente creada 'usuarios'
GRANT ALL PRIVILEGES on usuarios TO 'express_api' @'%';

-- Nota: si deseas utilizar el usuario solo en localhost, cambia
-- el % por la palabra localhost en las dos consultas anteriores

-- Recargar todos los permisos para actualizar el que hemos creado anteriormente
FLUSH PRIVILEGES;
```

---

### Ejecutar script sql

En vscode vamos a presionar las teclas <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>, escribiremos **Change active database** y escogeremos <kbd>mysql_root#mysql</kbd>

![Cambiar base de datos activa](assets/change_active_db.gif)

Presionar las las teclas <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd> para ejecutar el script

![Cambiar base de datos activa](assets/execute_sql_script.gif)

### Utilizar base de datos creada

Ahora que tenemos la base de datos y el usuario creado, crear nueva conexión con los siguientes valores:

|                       |             |
| --------------------- | ----------- |
| **Connection Name**   | mysql_api   |
| **Connection Target** | global      |
| **Database Type**     | mysql       |
| **Host**              | 127.0.0.1   |
| **Port**              | 3306        |
| **Username**          | express_api |
| **Password**          | express_api |
| **Databases**         |             |
| **Include Databases** | express_api |
| **ConnectTimeout**    | 5000        |
| **RequestTimeout**    | 10000       |
| **Timezone**          | +00:00      |
| **SSH Tunnel**        | desactivado |
| **Use SSL**           | desactivado |

Ahora debemos cambiar la base de datos activa:  
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>, escribiremos **Change active database** y escogeremos <kbd>mysql_api#express_api</kbd>

---

### Módulo de mysql

agrega el siguiente código al archivo **db.js**:

```javascript
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
```

> Algunas dudas que quizás tengas:  
> [¿Por qué las variables se declaran con <kbd>{}</kbd>?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#desestructuración)  
> [¿Qué significa **pool.queryPromisify** en el código?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#añadir-nuevo-método-a-un-objeto)  
> [¿Qué significa **process.env**?](#añadir-variables-de-entorno)  
> [¿Qué es **promisify** en Nodejs?](https://medium.com/@suyashmohan/util-promisify-in-node-js-v8-d07ef4ea8c53)  
> [¿Cúal es la diferencia entre utilizar un pool y una conexión a la base de datos?](https://es.stackoverflow.com/questions/359715/cu%C3%A1l-ser%C3%ADa-la-diferencia-entre-usar-un-pool-o-usar-una-conexion-tradicional-a-l)

---

## Index.js

El archivo index.js es nuestro archivo principal, en este declaramos nuestra API. abre el archivo **index.js** y sigue los siguientes pasos:

---

### 1. Importación de módulos y declaración de constantes

- Importamos el módulo de express y [nuestro módulo](#módulo-de-mysql) de la conexión a la base de datos.  
- Declaramos una dirección **IP** y un **Puerto** donde estará escuchando nuestra aplicación.  
- Indicarle a express que decodifique los datos que nos envían a través de una [solicitud HTTP](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#protocolo-http)

Agrega el siguiente código al archivo **index.js**

```javascript
require('dotenv').config()
const express = require("express")
const database = require("./db.js")
const { urlencoded, json } = express
const app = express()

const { NODE_IP: IP, NODE_PORT: PORT } = process.env

app.use(urlencoded({ extended: false }))
app.use(json())
```

> Algunas dudas que quizás tengas:  
> [¿Por qué las variables se declaran con <kbd>{}</kbd>?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#desestructuración)  
> [¿Qué significa **process.env**?](#añadir-variables-de-entorno)  
> [¿Que significa **urlencoded()** y **json()**?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#insert-set)

---

### 2. Declaración de formato de mensajes de respuesta

- Declaramos 2 [nuevos métodos](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#añadir-nuevo-método-a-un-objeto) para los objetos de tipo **response** que enviarán un [JSON](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#json) con la estructura de nuestros mensajes

- Para el caso de [**éxito**](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#jsonapi)

Agrega el siguiente código al archivo **index.js**

```javascript
express.response.sendMessage = function (data = undefined) {
    const body = {
        success: true,
        status: "success"
    }

    if (data !== undefined)
        body["data"] = data

    this.status(200).json(body)
}
```

- Para el caso de [**error**](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#jsonapi)

Agrega el siguiente código al archivo **index.js**

```javascript
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
```

> Algunas dudas que quizás tengas:  
> [¿Que significa **response**?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-mensaje-http)  
> [¿Que significa **status()**?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#códigos-de-estado-http)

---

### 3. Declaración de métodos de comprobación

- Declaramos un [nuevo método](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#añadir-nuevo-método-a-un-objeto) para los objetos de tipo **request** que comprobarán si los [datos](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#http-request) que nos envían a través de un [POST](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-métodos-http) o [PUT](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-métodos-http) están vacíos

Agrega el siguiente código al archivo **index.js**

```javascript
express.request.isBodyEmpty = function () {
    return Object.keys(this.body).length === 0
}
```

> Algunas dudas que quizás tengas:  
> [¿Que significa **request**?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-mensaje-http)  

---

### 4. Manejo de excepciónes de la base de datos

- Declaramos un objeto **mysqlErrors** que contiene un método para manejar una excepción especifica.

Agrega el siguiente código al archivo **index.js**

```javascript
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
```

| Error | Descripción |
| --- | --- |
| **ER_NO_DEFAULT_FOR_FIELD**| Este error ocurre cuando **omitimos** un campo y este está declarado como **NOT NULL** y además **NO** tiene un valor por defecto |
| **ER_BAD_FIELD_ERROR**| Este error ocurre cuando se desea **asignar** un campo **desconocido** a una tabla
| **ER_DUP_ENTRY**| Este error ocurre cuando se desea **actualizar** un **ID único** y otro registro ya lo tiene asignado

---

### 5. Declaración de métodos HTTP en nuestro servidor

Para declarar los [métodos HTTP](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-métodos-http) debemos de especificarlo con un <kbd>.</kbd> seguido de el tipo de método.  

Cada [método HTTP](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-métodos-http) debe de tener 2 argumentos:

1. **string**: Path [URI](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#http-request)
2. **método**: Manejador del método HTTP [arrow Functions](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#funciones-arrow)

Todo manejador (handler) recibirá por lo menos 2 argumentos:

1. **req** Un Objeto de tipo _express.[request](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-mensaje-http)_
2. **res** Un Objeto de tipo _express.[request](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-mensaje-http)_

Para acceder a las variables de los Objetos tipo request tenemos 3 maneras diferentes.

| Manera        | Descripción                | Método HTTP | Ejemplo                                      |
| ------------- | -------------------------- | ----------- | -------------------------------------------- |
| req.body.id   | Variable en los datos HTTP | POST\|PUT   | Enviar un formulario HTML con el método POST |
| req.query.id  | Variable en la URL         | ANY         | /api/usuario?id=1                            |
| req.params.id | Variable en la URI         | ANY         | /api/usuario/:id                             |

Nuestra [URI](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#http-request) será **"/api/usuarios"**

---

#### [GET](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-métodos-http)

Agrega el siguiente código al archivo **index.js**

```javascript
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

        if (usuario ===  undefined)
            return res.sendError(404, "Not found")

        return res.sendMessage(usuario)
    } catch (error) {
        console.error(error)

        return res.sendError(500, "Internal Server Error, " + error.message)
    }
})
```

> Algunas dudas que quizás tengas:  
> [¿Que significa **res** y **req**?](#5-declaración-de-métodos-http-en-nuestro-servidor)  
> [¿Qué significa **aync** y **await** en el código?](http://farzicoder.com/util-promisify-in-Node-js-v8/#Async-amp-Await)  
> [¿Qué significa **?** y el array en la consulta?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#sql-injection)

---

#### [POST](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-métodos-http)

Agrega el siguiente código al archivo **index.js**

```javascript
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
```

**error.code**: es un String, es el **nombre del error**  
Comprobamos si el error **existe** en nuestro objeto mysqlErrors. **Si existe**, **ejecutamos** el método asociado a ese error. **Si no existe**, enviamos el error "Internal Server Error"

> Algunas dudas que quizás tengas:  
> [¿Que significa **res** y **req**?](#5-declaración-de-métodos-http-en-nuestro-servidor)  
> [¿Qué significa **aync** y **await** en el código?](http://farzicoder.com/util-promisify-in-Node-js-v8/#Async-amp-Await)  
> [¿Qué significa **SET** en la consulta?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#insert-set)  
> [¿Qué significa **?** y el array en la consulta?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#sql-injection)

---

#### [PUT](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-métodos-http)

Agrega el siguiente código al archivo **index.js**

```javascript
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
```

**affectedRows**: (Filas afectadas) es un Int que nos indicará la cantidad de registros que fueron **actualizados**.  
Si esa variable es **igual a _0_**, quiere decir que **no existe** ningún registro con el ID pasado por parámetro.

**error.code**: es un String, es el **nombre del error**  
Comprobamos si el error **existe** en nuestro objeto mysqlErrors. **Si existe**, **ejecutamos** el método asociado a ese error. **Si no existe**, enviamos el error "Internal Server Error"

> Algunas dudas que quizás tengas:  
> [¿Que significa **res** y **req**?](#5-declaración-de-métodos-http-en-nuestro-servidor)  
> [¿Por qué la variable **affectedRows** se declara entre <kbd>{}</kbd>?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#desestructuración)  
> [¿Qué significa **aync** y **await** en el código?](http://farzicoder.com/util-promisify-in-Node-js-v8/#Async-amp-Await)  
> [¿Qué significa **SET** en la consulta?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#insert-set)  
> [¿Qué significa **?** y el array en la consulta?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#sql-injection)

---

#### [DELETE](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#tipos-de-métodos-http)

Agrega el siguiente código al archivo **index.js**

```javascript
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
```

**affectedRows**: (Filas afectadas) es un Int que nos indicará la cantidad de registros que fueron **eliminados**.  
Si esa variable es **igual a _0_**, quiere decir que **no existe** ningún registro con el ID pasado por parámetro.

> Algunas dudas que quizás tengas:  
> [¿Que significa **res** y **req**?](#5-declaración-de-métodos-http-en-nuestro-servidor)  
> [¿Por qué la variable **affectedRows** se declara entre <kbd>{}</kbd>?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#desestructuración)  
> [¿Qué significa **aync** y **await** en el código?](http://farzicoder.com/util-promisify-in-Node-js-v8/#Async-amp-Await)  
> [¿Qué significa **SET** en la consulta?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#insert-set)  
> [¿Qué significa **?** y el array en la consulta?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#sql-injection)

---

### 6. Poner en escucha el servidor

Debemos de indicarle al servidor que este en modo listening en el puerto y dirección ip declarada en el paso 1 y además cuando llegue una ruta desconocida, enviará el el código 404 not found

Agrega el siguiente código al archivo **index.js**

```javascript
app.use((req, res) => {
    res.sendError(404, "Not found, " + req.path)
})

app.listen(PORT, IP, () => console.log(`Listening in http://${IP}:${PORT}`))
```

---

## Código fuente completo

Package json: [package.json](https://github.com/srealmoreno/api-express/raw/finished/package.json)  
Script sql: [db.sql](https://github.com/srealmoreno/api-express/raw/finished/db.sql)  
Módulo de la base de datos: [db.js](https://github.com/srealmoreno/api-express/raw/finished/db.js)  
Archivo principal: [index.js](https://github.com/srealmoreno/api-express/raw/finished/index.js)  

---

## Poner en marcha nuestro servidor

En vscode vamos a presionar las teclas <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>, luego escribir 'Alternar Terminal'

Ejecutamos lo siguiente en la terminal:

```bash
npm start
```

![Abrir terminal integrada](assets/open_integrated_terminal.gif)

Si deseamos que nuestro servidor se reinicie automáticamente cada vez que modifiquemos cualquier archivo del proyecto ejecutamos

```bash
npm run dev
```

Si podemos ver el texto 'Listening in [http://127.0.0.1:3000](##)' quiere decir que nuestro servidor inició correctamente.

Ahora debemos ocultar la terminal haciendo click en el botón <kbd>X</kbd>

![Ocultar terminal integrada](assets/close_integrated_terminal.gif)

---

## Pruebas

Ahora que tenemos nuestro servidor en funcionamiento debemos hacer unas pruebas.  

---

### Crear colección en Thunder Client

Una colección es un grupo de solicitudes.  
En el apartado de [Thunder Client](#instalar-extensiones-en-vscode) (icono de rayo) debemos crear una nueva colección con nombre **Test node-api**

![Nueva colección](assets/new_collection.gif)

---

#### Crear solicitud GET

En nuestra colección crearemos un nuevo request con nombre **Obtener Usuarios**

![Nueva solicitud](assets/new_request.gif)

Rellena con los siguientes datos:

|            |                                          |
| ---------- | ---------------------------------------- |
| **url**    | [http://127.0.0.1:3000/api/usuarios](##) |
| **Método** | <kbd>GET</kbd>                           |

En la pestaña de <kbd>Headers</kbd> rellena con los siguientes datos:

|            |                             |
| ---------  | --------------------------- |
| **Accept** | <kbd>application/json</kbd> |

![GET](assets/request_get.gif)

En la pestaña de <kbd>Tests</kbd> rellena con los siguientes datos:

|                         |                  |                                 |
| ----------------------- | ---------------- | ------------------------------- |
| <kbd>ResponseCode</kbd> | <kbd>Equal</kbd> | 200                             |
| <kbd>ContentType</kbd>  | <kbd>Equal</kbd> | application/json; charset=utf-8 |
| json.success            | <kbd>Equal</kbd> | true                            |
| json.status             | <kbd>Equal</kbd> | sucess                          |

y por último <kbd>Ctrl</kbd> + <kbd>S</kbd> para guardar

![Tests](assets/request_tests.gif)

> Algunas dudas que quizás tengas:  
> [¿Que es <kbd>ResponseCode</kbd>?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#http-response)  
> [¿Que es <kbd>ContentType</kbd>?](https://github.com/srealmoreno/api-express/wiki/Conocimientos-preliminares#http-response)  
> [¿Qué es json.success y json.status?](#2-declaración-de-formato-de-mensajes-de-respuesta)  

---

#### Crear solicitud POST

Duplica el request anterior y cambiale el nombre a **Guardar Usuario**
![Solicitud GET](assets/duplicate_request.gif)

Rellena con los siguientes datos:

|            |                  |
| ---------- | ---------------- |
| **Método** | <kbd>POST</kbd>  |

En la pestaña de <kbd>Body</kbd>, escogeremos la opción <kbd>Form-encodec</kbd> y rellena con los siguientes datos:

|              |               |
| ------------ | ------------- |
| **nombre**   | _Tu nombre_   |
| **apellido** | _Tu apellido_ |
| **correo**   | _Tu correo_   |

y por último <kbd>Ctrl</kbd> + <kbd>S</kbd> para guardar

![Solicitud POST](assets/request_post.gif)

---

#### Crear solicitud PUT

Duplica el request **Guardar Usuario** y cambiale el nombre a **Actualizar Usuario**

Rellena con los siguientes datos:

Recuerda que en este método debemos de [indicarle el ID por la URL](#put) en este caso el ID será: **1**

|            |                                            |
| ---------- | ------------------------------------------ |
| **url**    | [http://127.0.0.1:3000/api/usuarios/1](##) |
| **Método** | <kbd>PUT</kbd>                            |

En la pestaña de <kbd>Body</kbd>, escogeremos la opción <kbd>Form-encodec</kbd> y rellena con los siguientes datos:

|              |                 |
| ------------ | --------------- |
| **nombre**   | _Otro nombre_   |
| **apellido** | _Otro apellido_ |
| **correo**   | _Otro correo_   |

y por último <kbd>Ctrl</kbd> + <kbd>S</kbd> para guardar

![Solicitud PUT](assets/request_put.gif)

---

#### Crear solicitud DELETE

Duplica el request **Obtener Usuarios** y cambiale el nombre a **Eliminar Usuario**  

Para tener un orden arrastras el request con el mouse de la siguiente manera:

![Solicitud POST](assets/move_request.gif)

Rellena con los siguientes datos:

Recuerda que en este método debemos de [indicarle el ID por la URL](#delete) en este caso el ID será: **1**

|            |                                            |
| ---------- | ------------------------------------------ |
| **url**    | [http://127.0.0.1:3000/api/usuarios/1](##) |
| **Método** | <kbd>DELETE</kbd>                          |

y por último <kbd>Ctrl</kbd> + <kbd>S</kbd> para guardar

![Solicitud DELETE](assets/request_delete.gif)

---

Al final debería verse así:

![Previsualización de collección](assets/preview_collection.png)

---

### Colección completa de Thunder Client

También puedes [descargar](tests/thunder_test.json) e importar la colección que hicimos en el paso anterior

![Importar colección](assets/import_collection.gif)

### Ejecución de pruebas

Para la ejecución de las pruebas es simple solo debemos ir a cada una de las solicitudes y hacer click en el botón <kbd>Send</kbd>

Cuando ejecutemos las pruebas tendremos 2 pestañas importantes:

<kbd>Response</kbd>: Es el Json con que responderá el servidor

<kbd>Test Results</kbd>: Serán el resultado de las pruebas, debemos obtener <kbd>Pass</kbd> en el resultado de cada prueba

Para no obtener el [error "Empty List"](#get) primero vamos a guardar un nuevo usuario.

---

#### Ejecución solicitud POST

![Ejecución solicitud POST](assets/run_request_post.gif)

---

#### Ejecución solicitud GET

Aquí veremos el usuario que se guardo en el test anterior

![Ejecución solicitud GET](assets/run_request_get.gif)

---

#### Ejecución solicitud PUT

Aquí modificaremos el usuario que se guardó

![Ejecución solicitud PUT](assets/run_request_put.gif)

Para comprobarlo podemos a volver a ejecutar la [primer prueba](#ejecución-solicitud-get)

![Ejecución solicitud PUT](assets/check_run_request_put.gif)

---

#### Ejecución solicitud DELETE

![Ejecución solicitud DELETE](assets/run_request_delete.gif)

---

## Wiki

HTTP:

[HTTP Messages and Structure](https://developer.mozilla.org/es/docs/Web/HTTP/Messages)  
[HTTP Request Methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)  
[HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)  

JavaScript:

[Destructuring assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)  
[Arrow Functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)  
[Monkey patch](https://en.wikipedia.org/wiki/Monkey_patch)

Base de datos:

[Express mysql](https://expressjs.com/es/guide/database-integration.html#mysql)  
[Pool Connection](https://es.wikipedia.org/wiki/Connection_pool)  
[Mysql pool](https://github.com/mysqljs/mysql#pooling-connections)  
[Promisify in Node](https://medium.com/@suyashmohan/util-promisify-in-node-js-v8-d07ef4ea8c53)  
[Mysql error codes](https://github.com/sambrmg/mysql-error-codes)  
[Sql Injection](https://en.wikipedia.org/wiki/SQL_injection)  
[Sql Injection in Nodejs](https://www.veracode.com/blog/secure-development/how-prevent-sql-injection-nodejs)

Json:

[Structure of Json](https://www.json.org/json-en.html)  
[JsonAPI](https://jsonapi.org/)  

Docker:

[Install](https://docs.docker.com/engine/install/linux/)  
[Docker Pull](https://docs.docker.com/engine/reference/commandline/pull/)  
[Docker Image](https://docs.docker.com/engine/reference/commandline/image/)  
[Docker Run](https://docs.docker.com/engine/reference/commandline/run/)  
[Docker Start](https://docs.docker.com/engine/reference/commandline/start/)  
[Docker Stop](https://docs.docker.com/engine/reference/commandline/stop/)  
[Docker mysql](https://hub.docker.com/_/mysql)

Express:

[Express api](https://expressjs.com/en/api.html)  
[Express json](https://expressjs.com/en/api.html#res.json)  
[Express urlencoded](https://expressjs.com/en/api.html#express.urlencoded)  
[Express request body](https://expressjs.com/en/api.html#req.body)  
[Express request query](https://expressjs.com/en/api.html#req.query)  
[Express request param](https://expressjs.com/en/api.html#app.param)  
[Express GET Method](https://expressjs.com/en/api.html#app.get.method)  
[Express POST Method](https://expressjs.com/en/api.html#app.post.method)  
[Express PUT Method](https://expressjs.com/en/api.html#app.put.method)  
[Express DELETE Method](https://expressjs.com/en/api.html#app.delete.method)  
[Express Response Status](https://expressjs.com/en/api.html#res.status)  

Extensiones vscode:

[Docker](https://github.com/microsoft/vscode-docker)  
[Database Client](https://github.com/cweijan/vscode-database-client)  
[Thunder Client](https://github.com/rangav/thunder-client-support)  

---

## Autor

| ![Srealmoreno](https://github.com/srealmoreno.png?size=115) |  [srealmoreno](https://github.com/srealmoreno) |
| :---: | :--: |

También puedes mirar la lista de todos los [contribuyentes](https://github.com/srealmoreno/api-express/contributors) quíenes han participado en este proyecto.

---

## Licencia

Este proyecto está bajo la Licencia GNU General Public License v3.0 - mira el archivo [LICENSE](LICENSE) para más detalles

---

Programación en Android - Salvador real

[![#](https://img.shields.io/github/followers/srealmoreno?label=Follow&style=social)](https://github.com/srealmoreno/)

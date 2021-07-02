# Conocimientos preliminares

## Indíce

- [Protocolo HTTP](#protocolo-http)
  - [Tipos de mensaje](#tipos-de-mensaje-http)
  - [Estructura de un mensaje](#estructura-de-un-mensaje-http)
    - [Request](#http-request)
    - [Response](#http-response)
  - [Tipos de métodos](#tipos-de-métodos-http)
  - [Códigos de estado](#códigos-de-estado-http)
- [JavaScript](#javascript)
  - [Desestructuración](#desestructuración)
  - [Funciones arrow](#funciones-arrow)
  - [Añadir nuevo método a un objeto](#añadir-nuevo-método-a-un-objeto)
- [Mysql](#mysql)
  - [Insert Set](#insert-set)
  - [SQL Injection](#sql-injection)
- [Json](#json)
  - [Estructura](#estructura-de-un-json)
  - [JsonAPI](#jsonapi)
- [Referencias](#referencias)

---

## Protocolo HTTP

HTTP, de sus siglas en inglés: "Hypertext Transfer Protocol", es el nombre de un protocolo el cual nos permite realizar una petición de datos y recursos, como pueden ser documentos HTML. Es la base de cualquier intercambio de datos en la Web, y un protocolo de estructura cliente-servidor, esto quiere decir que una petición de datos es iniciada por el elemento que recibirá los datos (el cliente)

---

### Tipos de mensaje HTTP

1. **request** (solicitud en español) es el mensaje que envía el **_cliente_**
2. **response** (respuesta en español) es el mensaje que envía el **_servidor_**

A menudo veremos estos mensajes abreviados como **req** y **res** respectivamente

![Tipos de mensajes http](https://raw.githubusercontent.com/srealmoreno/api-express/master/assets/http_messages.png)

---

### Estructura de un mensaje HTTP

#### HTTP **request**

Los elementos principales de un mensaje HTTP **request** son

- HTTP HEADER
  - METHOD
  - URI
- HTTP BODY
  - DATA

**Method**: (Método en español) Indica la acción que se desea realizar para un recurso determinado (lo veremos detalladamente en el siguiente punto). e.j _GET_

**URI**: (Identificador Uniforme de Recursos de sus siglas en inglés: Uniform Resource Identifier) es una cadena que se refiere a un recurso. Los más comunes son URLs, que identifican el recurso dando su ubicación en la Web. e.j /_api/usuarios_

**DATA**: (Datos en español) como su nombre lo indica, generalmente los datos enviados se codifican en HTTP BODY, si no hay ningún dato que enviar, es omitido. e.j cuando se envía un formulario HTML POST

#### HTTP **response**

Los elementos principales de un mensaje HTTP **response** son

- HTTP HEADER
  - STATUS CODE
  - CONTENT TYPE
- HTTP BODY
  - DATA

**STATUS CODE**: (Código de estado en español) Indica si se ha completado satisfactoriamente una solicitud (lo veremos detalladamente en el siguiente punto). e.j 200

**CONTENT TYPE**: (Tipo de contenido) Indica el tipo de contenido y codificación que esta enviando el servidor, e.j _text/html; charset=utf8_ indica que es una página web

**DATA**: Son los datos con los que responde el servidor, e.j una página web codificada en _UTF-8_

![Estructura http](https://raw.githubusercontent.com/srealmoreno/api-express/master/assets/http_structure.png)

En esta imagen podemos observar que la estructura de los mensajes es la siguiente:

**request**:

- HTTP HEADER
  - METHOD = GET
  - URI = /home.html

**response**:

- HTTP HEADER
  - STATUS CODE = 200
  - CONTENT TYPE = text/html
- HTTP BODY
  - DATA = \<html>....\</html>

---

### Tipos de métodos HTTP

El tipo de método determinará la acción o la operación CRUD que debemos hacer.

| Método     | Operación SQL | Descripción      |
| ---------- | ------------- | ---------------- |
| **GET**    | SELECT        | Leer datos       |
| **POST**   | INSERT        | Guardar datos    |
| **PUT**    | UPDATE        | Actualizar datos |
| **DELETE** | DELETE        | Eliminar datos   |

---

### Códigos de estado HTTP

Todo mensaje **response** debe de llevar un código de estado que describa el resultado de la solicitud.

- Respuestas informativas (100–199)
- Respuestas satisfactorias (200–299)
- Redirecciones (300–399)
- Errores de los clientes (400–499)
- y errores de los servidores (500–599)

En este tutorial solo utilizaremos los siguientes

| Código | Nombre                | Descripción                               |
| ------ | --------------------- | ----------------------------------------- |
| 200    | Ok                    | La solicitud tuvo éxito                   |
| 400    | Bad Request           | La solicitud es incorrecta                |
| 404    | Not Found             | El recurso solicitado no existe           |
| 409    | Conflict              | Hay un conflicto al procesar la solicitud |
| 500    | Internal Server Error | Error interno en el servidor              |

---

## JavaScript

### Desestructuración

La desestructuración es una característica muy conveniente al desarrollar con javascript, es una expresión que nos permite desempaquetar valores de arrays <kbd>[]</kbd> u objetos <kbd>{}</kbd> en grupos de variables, permitiéndonos simplificar y crear código más legible.

Ejemplo 1: No utilizando desestructuración de objetos <kbd>{}</kbd>

```javascript
var usuario = {
  nombre: "Salvador",
  edad: 22,
}

// Debemos acceder a una propiedad por un '.' y el nombre de la propiedad
var nombre = usuario.nombre 
var edad = usuario.edad
console.log(nombre, edad) // Salvador 22
```

Ejemplo 1: Utilizando desestructuración de objetos <kbd>{}</kbd>

Utilizando desestructuración para el anterior bloque de código sería:

```javascript
var usuario = {
  nombre: "Salvador",
  edad: 22,
}

// Las propiedades usuario.nombre y usuario.edad se asignan a las variables correspondientes sin importar su orden
// Debemos acceder a una propiedad por su nombre
var { nombre, edad } = usuario 

console.log(nombre, edad) // Salvador 22
```

Es importante escribir el nombre de la propiedad correctamente respetando las mayúsculas y minúsculas.

```javascript
var usuario = {
  nombre: "Salvador",
  edad: 22,
}

var { Nombre } = usuario

console.log(Nombre) // undefined ya que la propiedad es 'nombre' en minúscula
```

Ejemplo 2: No utilizando desestructuración de array's <kbd>[]</kbd>

```javascript
var usuario1 = {
  nombre: "Salvador",
  edad: 22,
}

var usuario2 = {
  nombre: "Lester",
  edad: 24,
}

var usuario3 = {
  nombre: "Omar",
  edad: 30,
}

var usuarios = [usuario1, usuario2, usuario3]

var u1 = usuarios[0]
var u3 = usuarios[2]

console.log(u1.nombre) // Salvador
console.log(u3.nombre) // Omar
```

Ejemplo 2: Utilizando desestructuración de array's <kbd>[]</kbd>

Utilizando desestructuración para el anterior bloque de código sería:

```javascript
var usuario1 = {
  nombre: "Salvador",
  edad: 22,
}

var usuario2 = {
  nombre: "Lester",
  edad: 24,
}

var usuario3 = {
  nombre: "Omar",
  edad: 30,
}

var usuarios = [usuario1, usuario2, usuario3]

// Los objetos se asignarán utilizando marcadores ',' de posición, aquí si importa el orden.
var [u1, , u3] = usuarios //Como puede observar para omitir un dato simplemente se escribe una ','

console.log(u1.nombre) // Salvador
console.log(u3.nombre) // Omar
```

Puede omitir asignación a una variable hacia la derecha, pero no hacia la izquierda ya que se utiliza un marcador de posición <kbd>,</kbd>

```javascript
var usuario1 = {
  nombre: "Salvador",
  edad: 22,
}

var usuario2 = {
  nombre: "Lester",
  edad: 24,
}

var usuario3 = {
  nombre: "Omar",
  edad: 30,
}

var usuarios = [usuario1, usuario2, usuario3]

var [u1] = usuarios

console.log(u1.nombre) // Salvador

var [u3] = usuarios // No se utiliza el marcador de posición

console.log(u3.nombre) // Salvador, Debería ser Omar!

var [, , u3] = usuarios // Se utiliza el marcador de posición

console.log(u3.nombre) // Omar
```

---

### Funciones arrow

Con EcmaScript podemos declarar métodos con menos código, utilizando funciones arrow (flecha en inglés ya que su operador es **=>**). e.j

```javascript
var hola = function (nombre) {
  console.log(`Hola ${nombre}!`)
}

var hola = (nombre) => {
  console.log(`Hola ${nombre}!`)
}

// Si la función solo ejecuta una instrucción podemos omitir las llaves
var hola = (nombre) => console.log(`Hola ${nombre}!`)

// Si la función solo recibe un parámetro podemos omitir los paréntesis
var hola = nombre => console.log(`Hola ${nombre}!`)
```

Un dato importante sobre las funciones arrow es que no tienen la referencia this, esto será muy importante para el siguiente punto.

---

### Añadir nuevo método a un objeto

_Monkey patching_ es una técnica para agregar, modificar o suprimir el comportamiento predeterminado de un fragmento de código en tiempo de ejecución sin cambiar su código fuente original. Esto es similar a [funciones de extension en kotlin](https://devexperto.com/funciones-extension-kotlin-android/)

Siguiendo el ejemplo de nuestra función anterior, debíamos de pasar por parámetro un nombre para imprimirlo:

```javascript
var hola = function (nombre) {
  console.log(`Hola ${nombre}!`)
}

var nombre = "Salvador"

hola(nombre) // Hola Salvador!
```

Sería más simple si podemos definir un nuevo método para los **strings** que haga lo mismo.
Para eso debemos definirlo de la siguiente manera:

```javascript
tipo_de_dato.prototype.nombre_funcion = function () {
  ...
}
```

```javascript
String.prototype.hola = function () {
  console.log(`Hola ${this}!`)
}
// Ahora cualquier string tendrá el método "hola"
// y podremos ahorrar pasar la string como parámetro del método

var nombre = "Salvador"

nombre.hola() //Hola Salador!
```

Si tenemos un objeto de **clave**<kbd>:</kbd>**valor** la palabra reservada **prototype** es omitida, en este caso el tipo de dato es **persona**

```javascript
var persona = {
  nombre: "Salvador",
}

persona.hola = function () {
  console.log(`Hola ${this.nombre}!`)
}

persona.hola() //Hola Salador!
```

---

## Mysql

### INSERT SET

Probablemente la sintaxis que utilizas para insertar datos en una tabla es la siguiente:

```sql
INSERT INTO usuarios (nombre, apellido, correo) VALUES ("Salvador", "Real","salvador@ejemplo.com")
```

En este tutorial utilizaremos con **SET**

```sql
INSERT INTO usuarios SET nombre="Salvador", apellido="Real", correo="salvador@ejemplo.com"
```

Dado que cuando se envían datos a tráves del protocolo HTTP, se [codifica](#http-request) como **clave**=**valor** y **express** nos devolverá respetando esa sintaxis

![Codificación de formulario](https://raw.githubusercontent.com/srealmoreno/api-express/master/assets/form_data.png)

Si estamos seguros de recibir los campos correctamente (cantidad de los campos) podemos utilizar la siguiente sintaxis

```javascript
app.use(urlencoded({ extended: false }))

// Obtenemos la misma consulta de arriba
query("INSERT INTO usuarios SET ?", [req.body])
// Pero si nos envían un dato que no esperamos recibir, obtendremos una excepción
// e.j Si nos envían:
// "nombre"  : "Salvador"
// "apellido": "Real"
// "correo"  : "salvador@ejemplo.com"
// "edad"    : 22
// "edad" no es una atributo/columna de nuestra base de datos.
// se ejecutaría la siguiente consulta:
//  INSERT INTO usuarios SET nombre="Salvador", apellido="Real", correo="salvador@ejemplo.com", edad=22
//  Obtendremos la siguiente excepción: "Unknown column 'edad' in 'field list'"
```

Si **no** estamos seguros de recibir los campos correctamente podemos utilizar la siguiente sintaxis

```javascript
app.use(urlencoded({ extended: false }))

const { nombre, apellido, correo } = req.body

// De esta manera solo introduciremos los datos específicos
query("INSERT INTO usuarios SET nombre = ?, apellido = ?, correo = ?", [
  nombre,
  apellido,
  correo,
])
```

Si no entiendes que significa **'?'** lee el siguiente punto.

---

### SQL Injection

La inyección de SQL es un tipo de ciberataque en el cual un usuario malicioso inserta o "inyecta" código SQL invasor dentro del código SQL programado, con el fin de quebrantar las medidas de seguridad y acceder a datos protegidos.

Por ejemplo tenemos la siguiente consulta SQL elimina un usuario por un ID

```javascript
query("DELETE FROM usuarios WHERE id=" + req.body.id)
```

Ejecutar la consulta de esa manera tiene un gran problema ya que la variable **id** puede tener cualquier valor que es enviado por un usuario. e.j

¿Que pasaría si la variable **id** tuviese el valor "**1**"?

Esta es la consulta que se ejecutaría en la base de datos

```sql
DELETE FROM usuarios WHERE id=1
-- Solo se eliminaría el usuario con id igual a 1
-- Nuestra consulta funciona perfectamente como lo esperado
```

¿Que pasaría si la variable **id** tuviese el valor "**1 or 1 = 1**"?

Esta es la consulta que se ejecutaría en la base de datos

```sql
DELETE FROM usuarios WHERE id=1 or 1 = 1
-- Se inyectó el código 'or 1 = 1'
-- ya que es un or y "1 = 1" siempre es True
-- Se eliminarían todos los registros de la tabla usuario
-- Nuestra consulta no funciona como lo esperado, debído a un comportamiento
-- malintencionado
```

La solución es sencilla. Debemos modificar el código para que cualquier entrada del usuario se escape automáticamente antes de ejecutarse.

Tiene dos opciones para solucionar este problema:

- Marcadores de posición **"?"**

Puede asignar valores en la matriz a marcadores de posición (los signos de interrogación) en el mismo orden en que se pasan.

```javascript
query("DELETE FROM usuarios WHERE id = ?", [req.body.id])

//Por ejemplo que elimine si el id y el nombre concuerdan
query("DELETE FROM usuarios WHERE id = ? AND nombre = ?", [
  req.body.id,
  req.body.nombre,
])
```

- Marcadores de posición con nombre

Esto es casi idéntico al ejemplo anterior, sin embargo, los nombres de los atributos dentro del objeto se convierten en marcadores de posición en la consulta SQL.

```javascript
query("DELETE FROM usuarios WHERE id = :id", { id: req.body.id })

//Por ejemplo que elimine si el id y el nombre concuerdan
query("DELETE FROM usuarios WHERE id = :id AND nombre = :nombre", {
  id: req.body.id,
  nombre: req.body.nombre,
})
```

---

## Json

(JavaScript Object Notation - Notación de Objetos de JavaScript) es un formato ligero de intercambio de datos. Leerlo y escribirlo es simple para humanos, mientras que para las máquinas es simple interpretarlo y generarlo.

---

### Estructura de un Json

JSON está constituído por dos estructuras:

1. Una colección de pares de nombre/valor. En varios lenguajes esto es conocido como un objeto, registro estructura, diccionario, tabla hash, lista de claves o un arreglo asociativo.

2. Una lista ordenada de valores. En la mayoría de los lenguajes, esto se implementa como arreglos, vectores, listas o sequencias.

Estas son estructuras universales virtualmente todos los lenguajes de programación las soportan de una forma u otra. Es razonable que un formato de intercambio de datos que es independiente del lenguaje de programación se base en estas estructuras.

En JSON, se presentan de estas formas:

Un objeto comienza con <kbd>{</kbd> y termina con <kbd>}</kbd>. Cada nombre es seguido por <kbd>:</kbd> y los pares nombre/valor están separados por <kbd>,</kbd>

Un valor puede ser una cadena de caracteres con comillas dobles, o un número, o true o false o null, o un objeto o un arreglo.

```json
{
  "nombre": "Salvador",
  "apellido": "Real",
  "edad": 22,
  "correo": null,
  "vivo": true
}
```

Un arreglo comienza con <kbd>[</kbd> y termina con <kbd>]</kbd> Los valores se separan por <kbd>,</kbd>

```json
[
  {
    "nombre": "Salvador",
    "apellido": "Real",
    "edad": 22
  },
  {
    "nombre": "Lester",
    "apellido": "Vega",
    "edad": 23
  },
  {
    "nombre": "Omar",
    "apellido": "Rizo",
    "edad": 30
  }
]
```

---

### JsonApi

Siguiendo el estandar de [JsonApi](https://jsonapi.org/) y tomando de ejemplo la api de [Facebook](https://developers.facebook.com/docs/graph-api/using-graph-api/error-handling/) nuestros mensajes tendrán 2 estructuras principales:

- En caso de **éxito** el formato json será el siguiente

```json
{
  "success": true,
  "status": "success",
  "data": [
    {
      ...
    }
  ]
}
```

**success**: (éxito) es una variable Bolean que indicará si la transacción se ejecutó exitosamente

**status**: (estado) es una variable String que indicará si la transacción se ejecutó exitosamente

**data**: (datos) es un array de Objetos que contendrá los datos devueltos

- En caso de **error** el formato json será el siguiente

```json
{
  "success": false,
  "status": "failed",
  "error": {
    "code": 404,
    "message": "Not found"
  }
}
```

Para los mensajes de error podemos utilizar los [códigos de estado HTTP](#códigos-de-estado-http)

**success**: (éxito) es una variable Bolean que indicará si la transacción se ejecutó exitosamente

**status**: (estado) es una variable String que indicará si la transacción se ejecutó exitosamente

**error**: es un objeto que contendrá el código y mensaje de error

**code**: (código) es una variable numérica que indicará el código de error

**message**:(mensaje) es una variable String que indicará en lenguaje natural la razón del error

---

## Referencias

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

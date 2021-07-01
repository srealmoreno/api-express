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
# Sistema de gestión de videoclub: diseño de base de datos


## 1. Interpretación del problema

Este sistema de base de datos busca digitalizar y optimizar la gestión operativa de un videoclub. Su objetivo principal es mantener un registro centralizado y consistente de los socios, el catálogo de películas (resolviendo el problema de homónimos mediante identificadores compuestos), la ubicación física del inventario en archivadores y el historial de transacciones de alquiler. Además, el sistema garantiza la integridad de los datos al normalizar atributos multivaluados (como los actores de una película o los directores favoritos de un socio), evitando redundancias y anomalías de actualización.

## 2. Identificación de entidades y atributos


### Entidad: Socio

- **Atributos:**
  - `id_socio` (Simple, Identificador único).
  - `nombre` (Simple).
  - `direccion` (Simple, aunque podría descomponerse, se maneja como un campo de texto unificado para este alcance).
  - `telefono` (Simple).
- **Clave Primaria (PK):** id_socio.
- **Atributo Multivaluado:** directores_favoritos (Un socio puede tener varios).

### Entidad: Película

- **Atributos:**
  - `titulo` (Simple).
  - `director` (Simple).
  - `anio` (Simple).
  - `genero` (Simple).
- **Clave Primaria (PK):** Compuesta por (titulo, director, anio), ya que el enunciado especifica que esta combinación identifica unívocamente a la película.
- **Atributo Multivaluado:** reparto (actores).

### Entidad: Archivador

- **Atributos:**
  - `num_serie` (Simple, Identificador único).
  - `ubicacion` (Simple).
  - `num_estanterias` (Simple).
  - `fecha_compra` (Simple).
- **Clave Primaria (PK):** num_serie.

### Entidad Asociativa: Alquiler (Derivada de la relación N:M)

- **Atributos:**
  - `id_alquiler` (Simple, clave subrogada para facilitar la gestión).
  - `fecha_alquiler` (Simple).
  - `fecha_devolucion` (Simple, puede ser nulo si aún no se devuelve).
- **Clave Primaria (PK):** id_alquiler.

## 3. Justificación de relaciones y cardinalidades


### Archivador - Película (1:N)

- **Regla de negocio:** "Cada película pertenece a un único archivador, pero un archivador puede contener muchas películas".
- **Cardinalidad:** 1 a Muchos. La clave foránea (num_serie) se coloca en el lado "N" (entidad Película).

### Socio - Película (N:M)

- **Regla de negocio:** "Un socio puede alquilar muchas películas y una misma película puede ser alquilada por distintos socios a lo largo del tiempo".
- **Cardinalidad:** Muchos a Muchos. Se resuelve creando una entidad asociativa llamada Alquiler.

### Socio - Director Favorito (1:N)

- **Regla de negocio:** "Un socio puede tener varios directores favoritos".
- **Cardinalidad:** 1 a Muchos. Se resuelve creando una tabla independiente para cumplir con la Primera Forma Normal (1FN).

### Película - Actor (1:N)

- **Regla de negocio:** "Una película cuenta con un reparto de varios actores".
- **Cardinalidad:** 1 a Muchos. Se resuelve creando una tabla independiente para cumplir con la 1FN.

## 4. Transformación al modelo relacional

El proceso de transformación del DER al modelo relacional siguió estas reglas estándar de normalización:
- **Entidades fuertes:** Se crearon tablas para Socio, Archivador y Película con sus respectivos atributos simples.
- **Resolución de atributos multivaluados:**
Para los directores favoritos, se creó la tabla Socio_Director_Favorito. Su PK es compuesta (id_socio, nombre_director) e incluye una FK hacia Socio.
Para el reparto de actores, se creó la tabla Pelicula_Actor. Su PK es compuesta (titulo, director, anio, nombre_actor) e incluye una FK compuesta hacia Película.
- **Resolución de relación 1:**N (Archivador-Película): Se añadió la columna num_serie_archivador como Clave Foránea (FK) en la tabla Película, apuntando a la PK de Archivador.
- **Resolución de relación N:**M (Alquiler): Se creó la tabla Alquiler. Contiene su propia PK subrogada (id_alquiler) para simplificar las consultas, y dos Claves Foráneas: id_socio (hacia Socio) y la combinación (titulo, director, anio) (hacia Película).

## 5. Decisiones de diseño

- **Clave Primaria Compuesta en Película:** Se decidió estrictamente usar (titulo, director, anio) como PK en lugar de un ID artificial (como id_pelicula). Esto obedece directamente al requisito del negocio: "Dado que puede haber películas con el mismo nombre, se identifican por la combinación de título, director y año". Esto garantiza la integridad referencial sin depender de un identificador externo no mencionado en los requisitos.
- **Clave Subrogada en Alquiler:** Aunque la PK de Alquiler podría ser compuesta (id_socio, titulo, director, anio, fecha_alquiler), se optó por una clave subrogada (id_alquiler AUTO_INCREMENT). Esto mejora el rendimiento de los índices, simplifica las consultas de historial y facilita la posible futura adición de atributos a la transacción (ej: monto_pagado, estado_del_alquiler).
- **Integridad Referencial:** Se asume que las Claves Foráneas tendrán restricciones ON DELETE RESTRICT (o CASCADE según la política del videoclub) para evitar que se elimine un archivador con películas asignadas, o un socio con alquileres activos, preservando la consistencia histórica de los datos.

## Archivos

- [Script SQL](Modelo_Logico/script_sql.sql)
- [Diagrama](Diagramas/image.png)

## Autor

Juan José Acevedo Morales, desarrollador de software junior.
[Portafolio](https://juanacevedo124.github.io/Portafolio/) | [GitHub](https://github.com/JuanAcevedo124) | [LinkedIn](https://www.linkedin.com/in/juan-acevedo-b24759450/)

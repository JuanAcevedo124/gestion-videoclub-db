-- Tabla: Archivador
CREATE TABLE Archivador (
    num_serie VARCHAR(50) PRIMARY KEY,
    ubicacion VARCHAR(100) NOT NULL,
    num_estanterias INT CHECK (num_estanterias > 0),
    fecha_compra DATE NOT NULL
);

-- Tabla: Socio
CREATE TABLE Socio (
    id_socio INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20)
);

-- Tabla: Socio_Director_Favorito (Resuelve atributo multivaluado)
CREATE TABLE Socio_Director_Favorito (
    id_socio INT,
    nombre_director VARCHAR(100),
    PRIMARY KEY (id_socio, nombre_director),
    FOREIGN KEY (id_socio) REFERENCES Socio(id_socio) ON DELETE CASCADE
);

-- Tabla: Película (PK Compuesta según regla de negocio)
CREATE TABLE Pelicula (
    titulo VARCHAR(255),
    director VARCHAR(100),
    anio INT,
    genero VARCHAR(50),
    num_serie_archivador VARCHAR(50),
    PRIMARY KEY (titulo, director, anio),
    FOREIGN KEY (num_serie_archivador) REFERENCES Archivador(num_serie) ON DELETE RESTRICT
);

-- Tabla: Pelicula_Actor (Resuelve atributo multivaluado)
CREATE TABLE Pelicula_Actor (
    titulo VARCHAR(255),
    director VARCHAR(100),
    anio INT,
    nombre_actor VARCHAR(100),
    PRIMARY KEY (titulo, director, anio, nombre_actor),
    FOREIGN KEY (titulo, director, anio) REFERENCES Pelicula(titulo, director, anio) ON DELETE CASCADE
);

-- Tabla: Alquiler (Entidad asociativa N:M)
CREATE TABLE Alquiler (
    id_alquiler INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    director VARCHAR(100) NOT NULL,
    anio INT NOT NULL,
    fecha_alquiler DATE NOT NULL,
    fecha_devolucion DATE,
    FOREIGN KEY (id_socio) REFERENCES Socio(id_socio) ON DELETE RESTRICT,
    FOREIGN KEY (titulo, director, anio) REFERENCES Pelicula(titulo, director, anio) ON DELETE RESTRICT
);
# Creación de base de datos y de las tablas  

CREATE TABLE aerolineas (
    ID_AEROLINEA int(3) NOT NULL AUTO_INCREMENT,
    NOMBRE_AEROLINEA varchar(30) NOT NULL,
    CONSTRAINT PK_aerolinea PRIMARY KEY (ID_AEROLINEA)
);

CREATE TABLE aeropuertos (
    ID_AEROPUERTO int(3) NOT NULL AUTO_INCREMENT,
    NOMBRE_AEROPUERTO varchar(30) NOT NULL,
    CONSTRAINT PK_aeropuerto PRIMARY KEY (ID_AEROPUERTO)
);

CREATE TABLE movimientos (
    ID_MOVIMIENTO int(3) NOT NULL AUTO_INCREMENT,
    DESCRIPCION varchar(30) NOT NULL,
    CONSTRAINT PK_movimiento PRIMARY KEY (ID_MOVIMIENTO)
);

CREATE TABLE vuelos (
    DIA date NOT NULL,
    ID_AEROLINEA int(3) NOT NULL,
    ID_AEROPUERTO int(3) NOT NULL,
    ID_MOVIMIENTO int(3) NOT NULL,
    CONSTRAINT FK_aerolinea FOREIGN KEY (ID_AEROLINEA) REFERENCES aerolineas(ID_AEROLINEA),
    CONSTRAINT FK_aeropuerto FOREIGN KEY (ID_AEROPUERTO) REFERENCES aeropuertos(ID_AEROPUERTO),
    CONSTRAINT FK_movimiento FOREIGN KEY (ID_MOVIMIENTO) REFERENCES movimientos(ID_MOVIMIENTO)
);


# Ingreso de los datos a las tablas 

INSERT INTO aerolineas (NOMBRE_AEROLINEA) VALUES ('Volaris');
INSERT INTO aerolineas (NOMBRE_AEROLINEA) VALUES ('Aeromar');
INSERT INTO aerolineas (NOMBRE_AEROLINEA) VALUES ('Interjet');
INSERT INTO aerolineas (NOMBRE_AEROLINEA) VALUES ('Aeromexico');

INSERT INTO aeropuertos (NOMBRE_AEROPUERTO) VALUES ('Benito Juarez');
INSERT INTO aeropuertos (NOMBRE_AEROPUERTO) VALUES ('Guanajuato');
INSERT INTO aeropuertos (NOMBRE_AEROPUERTO) VALUES ('La paz');
INSERT INTO aeropuertos (NOMBRE_AEROPUERTO) VALUES ('Oaxaca');

INSERT INTO movimientos (DESCRIPCION) VALUES ('Salida');
INSERT INTO movimientos (DESCRIPCION) VALUES ('Llegada');

INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (1, 1, 1, '2021-05-02');
INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (2, 1, 1, '2021-05-02');
INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (3, 2, 2, '2021-05-02');
INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (4, 3, 2, '2021-05-02');
INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (1, 3, 2, '2021-05-02');
INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (2, 1, 1, '2021-05-02');
INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (2, 3, 1, '2021-05-04');
INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (3, 4, 1, '2021-05-04');
INSERT INTO vuelos (ID_AEROLINEA, ID_AEROPUERTO, ID_MOVIMIENTO, DIA) VALUES (3, 4, 1, '2021-05-04');


# ¿Cuál es el nombre aeropuerto que ha tenido mayor movimiento durante el año?

SELECT NOMBRE_AEROPUERTO AS 'AEROPUERTOS CON MÁS MOVIMIENTOS DURANTE EL AÑO 2021'
FROM aeropuertos
WHERE ID_AEROPUERTO IN (
    SELECT A.ID_AEROPUERTO
    FROM (
        SELECT ID_AEROPUERTO, COUNT(ID_AEROPUERTO) AS VUELOS, DATE_FORMAT(DIA, '%Y') AS ANO
        FROM vuelos
        GROUP BY ID_AEROPUERTO, DATE_FORMAT(DIA, '%Y')
    ) A
    WHERE A.ANO = '2021' 
    AND A.VUELOS = (
        SELECT MAX(M.VUELOS)
        FROM (
            SELECT ID_AEROPUERTO, COUNT(ID_AEROPUERTO) AS VUELOS, DATE_FORMAT(DIA, '%Y') AS ANO
            FROM vuelos
            GROUP BY ID_AEROPUERTO, DATE_FORMAT(DIA, '%Y')
        ) M
        WHERE M.ANO = '2021'
    )
);



#¿Cuál es el nombre aerolínea que ha realizado mayor número de vuelos durante el año?


SELECT NOMBRE_AEROLINEA AS 'AEROLÍNEAS CON MAYOR NÜMERO DE VUELOS DURANTE 2021'
FROM aerolineas
WHERE ID_AEROLINEA IN (
    SELECT V.ID_AEROLINEA
    FROM (
        SELECT ID_AEROLINEA, COUNT(ID_AEROLINEA) AS VUELOS, DATE_FORMAT(DIA, '%Y') as ANO
        FROM vuelos
        GROUP BY ID_AEROLINEA, DATE_FORMAT(DIA, '%Y')
    ) V
    WHERE V.ANO = '2021'
    AND V.VUELOS = (
        SELECT MAX(MOVS.VUELOS)
        FROM (
            SELECT ID_AEROLINEA, COUNT(ID_AEROLINEA) AS VUELOS, DATE_FORMAT(DIA, '%Y') as ANO
            FROM vuelos
            GROUP BY ID_AEROLINEA, DATE_FORMAT(DIA, '%Y')
        ) MOVS
        WHERE MOVS.ANO = '2021'
    )
);


#¿En qué día se han tenido mayor número de vuelos?

SELECT M.FECHA AS 'DIA DE MAYOR NÚMERO DE VUELOS'
FROM (
    SELECT DATE_FORMAT(DIA, '%b %d %Y') AS FECHA, COUNT(DATE_FORMAT(DIA, '%d')) AS VUELOS
	FROM vuelos
	GROUP BY DATE_FORMAT(DIA, '%d'),DATE_FORMAT(DIA, '%b %d %Y')
) M
WHERE M.VUELOS = (
    SELECT MAX(V.VUELOS)
    FROM (
        SELECT DATE_FORMAT(DIA, '%b %d %Y') AS FECHA, COUNT(DATE_FORMAT(DIA, '%d')) AS VUELOS
        FROM vuelos
        GROUP BY DATE_FORMAT(DIA, '%d'),DATE_FORMAT(DIA, '%b %d %Y')
    ) V
);


#¿Cuáles son las aerolíneas que tienen mas de 2 vuelos por día?

SELECT NOMBRE_AEROLINEA AS 'AEROLÍNEAS CON MÁS DE DOS VUELOS POR DÍA'
FROM aerolineas
WHERE ID_AEROLINEA IN (
SELECT V.ID_AEROLINEA 
FROM (
	SELECT ID_AEROLINEA, COUNT(DATE_FORMAT(DIA, '%d')) AS VUELOS, DIA
    FROM vuelos
    GROUP BY ID_AEROLINEA, DIA
) V
WHERE V.VUELOS > 2
);


/*

1. ¿Cuál es el nombre aeropuerto que ha tenido mayor movimiento durante el año?
  
Los aeropuertos con mayor movimiento durante 2021 son el aeropuerto Benito Juárz y La Paz.
 
2. ¿Cuál es el nombre de la aerolínea que ha realizado mayor número de vuelos durante el año?

Durante 2021 son dos las aerolíneas que han realizado la mayor cantidad de vuelos. Sus nombreson Aeromar e Interjet.
 
3. ¿En qué día se han tenido mayor número de vuelos?

El 2 de mayo del 2021 es el día en el que se han regstrado la mayor cantidad de vuelos.
 
4. ¿Cuáles son las aerolíneas que tienen mas de 2 vuelos por día?

Ninguna aerolínea tiene más de dos vuelos por día. Tiene exactamnte dos o menos.

*/


FIN DEL DOCUMENTO
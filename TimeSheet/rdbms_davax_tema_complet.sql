--PAS 1 - user
CREATE TABLESPACE davax_data_tema 
  DATAFILE '/opt/oracle/oradata/davax_data_tema.dbf' 
  SIZE 100M AUTOEXTEND ON NEXT 10M;

CREATE TABLESPACE davax_index_tema 
  DATAFILE '/opt/oracle/oradata/davax_index_tema.dbf' 
  SIZE 50M AUTOEXTEND ON NEXT 5M;

CREATE USER davax_tema IDENTIFIED BY davax_pass 
  DEFAULT TABLESPACE davax_data_tema 
  TEMPORARY TABLESPACE temp;

GRANT CONNECT, RESOURCE TO davax_tema;

ALTER USER davax_tema QUOTA UNLIMITED ON davax_data_tema;
ALTER USER davax_tema QUOTA UNLIMITED ON davax_index;

--Pas 4 - pt view
GRANT CREATE VIEW TO davax_tema;
GRANT CREATE MATERIALIZED VIEW TO davax_tema;


--Pas 2 - tabele
-- CREAREA TABELOR DE BAZA
CREATE TABLE Departamente (
    dept_id NUMBER PRIMARY KEY,
    nume VARCHAR2(100) NOT NULL,
    locatie VARCHAR2(100),
    CONSTRAINT uq_departamente_nume UNIQUE (nume)
);

CREATE TABLE Angajati (
    angajat_id NUMBER PRIMARY KEY,
    nume VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    salariu NUMBER(8,2) CHECK (salariu > 0),
    dept_id NUMBER,
    data_angajarii DATE DEFAULT SYSDATE,
    detalii JSON,
    CONSTRAINT fk_angajat_dept FOREIGN KEY (dept_id)
        REFERENCES Departamente(dept_id)
);

-- INDEX SUPLIMENTAR PE NUME
CREATE INDEX idx_angajati_nume ON Angajati(nume);

CREATE TABLE Pontaje (
    pontaj_id NUMBER PRIMARY KEY,
    angajat_id NUMBER NOT NULL,
    data_zi DATE NOT NULL,
    ore_lucrate NUMBER(3,1) CHECK (ore_lucrate BETWEEN 0 AND 24),
    activitate VARCHAR2(255),
    CONSTRAINT fk_pontaj_angajat FOREIGN KEY (angajat_id)
        REFERENCES Angajati(angajat_id),
    CONSTRAINT uq_pontaj_unique UNIQUE (angajat_id, data_zi)
);


--Pas 3 Inserare
-- INSERARE DATE DEPARTAMENTE
INSERT INTO Departamente VALUES (1, 'IT', 'Bucuresti');
INSERT INTO Departamente VALUES (2, 'HR', 'Cluj');

-- INSERARE DATE ANGAJATI
INSERT INTO Angajati VALUES (101, 'Andrei Popescu', 'andrei.popescu@endava.com', 8000, 1, TO_DATE('2022-01-10', 'YYYY-MM-DD'), '{"competente": ["SQL", "Python"]}');
INSERT INTO Angajati VALUES (102, 'Ioana Ionescu', 'ioana.ionescu@endava.com', 6500, 2, TO_DATE('2023-03-15', 'YYYY-MM-DD'), '{"competente": ["HR", "Recrutare"]}');
INSERT INTO Angajati VALUES (103, 'Maria Enache', 'maria.enache@endava.com', 7000, 1, TO_DATE('2021-11-01', 'YYYY-MM-DD'), '{"competente": ["Java", "DevOps"]}');

-- INSERARE DATE PONTAJE
INSERT INTO Pontaje VALUES (201, 101, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 8, 'Dezvoltare backend');
INSERT INTO Pontaje VALUES (202, 101, TO_DATE('2024-06-02', 'YYYY-MM-DD'), 6, 'Intalniri echipa');
INSERT INTO Pontaje VALUES (203, 102, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 7.5, 'Interviuri');
INSERT INTO Pontaje VALUES (204, 103, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 8, 'Configurare CI/CD');
INSERT INTO Pontaje VALUES (205, 103, TO_DATE('2024-06-02', 'YYYY-MM-DD'), 7, 'Mentorat juniori');

-- TESTARI CONSTRAINTURI
-- 1. Test UNIQUE pe email
-- INSERT INTO Angajati VALUES (104, 'Test', 'andrei.popescu@endava.com', 5000, 1, SYSDATE, '{}'); -- va da eroare

-- 2. Test CHECK (salariu negativ)
-- INSERT INTO Angajati VALUES (105, 'Test2', 'test2@endava.com', -1000, 1, SYSDATE, '{}'); -- va da eroare

-- 3. Test FOREIGN KEY (departament inexistent)
-- INSERT INTO Angajati VALUES (106, 'Test3', 'test3@endava.com', 4000, 99, SYSDATE, '{}'); -- va da eroare

-- 4. Test UNIQUE (pontaj duplicat in aceeasi zi)
-- INSERT INTO Pontaje VALUES (206, 101, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 4, 'Task duplicat'); -- va da eroare

-- 5. Test CHECK (ore lucrate peste 24)
-- INSERT INTO Pontaje VALUES (207, 101, TO_DATE('2024-06-03', 'YYYY-MM-DD'), 30, 'Suprasarcina'); -- va da eroare


--Pas 4 - view
-- VIEW: total ore per angajat
CREATE VIEW vw_total_ore AS
SELECT 
    a.angajat_id, 
    a.nume, 
    SUM(p.ore_lucrate) AS total_ore
FROM Angajati a
JOIN Pontaje p ON a.angajat_id = p.angajat_id
GROUP BY a.angajat_id, a.nume;

SELECT * FROM vw_total_ore;


-- Pas 5 - materialized view
-- MATERIALIZED VIEW: total ore pe departament
CREATE MATERIALIZED VIEW mv_ore_departament
BUILD IMMEDIATE
REFRESH COMPLETE
AS
SELECT 
    d.dept_id,
    d.nume AS dept_nume,
    SUM(p.ore_lucrate) AS total_ore
FROM Departamente d
JOIN Angajati a ON d.dept_id = a.dept_id
JOIN Pontaje p ON a.angajat_id = p.angajat_id
GROUP BY d.dept_id, d.nume;

SELECT * FROM mv_ore_departament;


-- Pas 6 - SELECT cu GROUP BY
-- Afisam orele totale lucrate de fiecare angajat, grupand pontajele pe angajat si insumand orele lucrate
SELECT 
    angajat_id, 
    SUM(ore_lucrate) AS total_ore
FROM Pontaje
GROUP BY angajat_id;


-- Pas 7 - SELECT cu LEFT JOIN
-- Afisam angajatii si orele lucrate, inclusiv cei fara pontaje
SELECT 
    a.nume, 
    p.data_zi, 
    p.ore_lucrate
FROM Angajati a
LEFT JOIN Pontaje p ON a.angajat_id = p.angajat_id;


-- Pas 8 - functie analitica
-- SELECT cu functie analitica (AVG)
-- Afisam orele lucrate de fiecare angajati si media departamentului lor
SELECT 
    a.nume, 
    p.ore_lucrate,
    AVG(p.ore_lucrate) OVER (PARTITION BY a.dept_id) AS media_ore_dept
FROM Angajati a
JOIN Pontaje p ON a.angajat_id = p.angajat_id;

-- SELECT cu functie analitica (RANK)
-- Clasificam angajatii dupa totalul orelor lucrate descrescator
SELECT 
    a.nume,
    SUM(p.ore_lucrate) AS total_ore,
    RANK() OVER (ORDER BY SUM(p.ore_lucrate) DESC) AS clasament_efort
FROM Angajati a
JOIN Pontaje p ON a.angajat_id = p.angajat_id
GROUP BY a.nume;

-- SELECT - JSON
-- Afisare date din coloana JSON
SELECT 
    angajat_id,
    nume,
    JSON_VALUE(detalii, '$.competente[0]') AS prima_competenta
FROM Angajati;

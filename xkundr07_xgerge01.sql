-- Banka

DROP TABLE Klient CASCADE CONSTRAINTS;
DROP TABLE Ucet CASCADE CONSTRAINTS;
DROP TABLE Disponent CASCADE CONSTRAINTS;
DROP TABLE Operace CASCADE CONSTRAINTS;
DROP TABLE Vklad CASCADE CONSTRAINTS;
DROP TABLE Vyber CASCADE CONSTRAINTS;
DROP TABLE Prevod CASCADE CONSTRAINTS;
DROP TABLE V_bance CASCADE CONSTRAINTS;
DROP TABLE Mimo_banku CASCADE CONSTRAINTS;

--BEGIN
--    FOR i IN (SELECT table_name FROM user_tables WHERE table_name IN ('Klient', 'Ucet', 'Disponent', 'Operace')) LOOP
--        EXECUTE IMMEDIATE 'DROP TABLE ' || i.table_name || ' CASCADE CONSTRAINTS';
--    END LOOP;
--EXCEPTION
--    WHEN OTHERS THEN
--        NULL; -- Ignore any errors if tables don't exist
--END;

--Entita
CREATE TABLE Klient (
    r_cislo CHAR(11),
    jmeno VARCHAR(255) NOT NULL,
    prijmeni VARCHAR(255) NOT NULL,
    adresa VARCHAR(255),
    telefon VARCHAR(255),
    email VARCHAR(255)
);

--Entita
CREATE TABLE Ucet (
    c_uctu INTEGER,
    r_cislo CHAR(11) NOT NULL,
    stav DECIMAL(10,2),
    c_banky INTEGER,
    predcisli INTEGER,
    iban VARCHAR(255)
);

--Klient_Ucet many to many relation
CREATE TABLE Disponent (
    r_cislo CHAR(11),
    c_uctu INTEGER
);

--Entita
CREATE TABLE Operace (
    c_transakce INTEGER,
    c_uctu INTEGER,
    cas TIMESTAMP,
    castka DECIMAL(10,2)
);

--Subtype Operace
CREATE TABLE Vklad (
    c_transakce INTEGER,
    c_uctu INTEGER,
    misto_vkladu VARCHAR(255)
);

--Subtype Operace
CREATE TABLE Vyber (
    c_transakce INTEGER,
    c_uctu INTEGER,
    misto_vyberu VARCHAR(255)
);

--Subtype Operace
CREATE TABLE Prevod (
    c_transakce INTEGER,
    c_uctu INTEGER,
    proti_c_uctu INTEGER,
    proti_predcisli INTEGER
);

--Subtype Prevod
CREATE TABLE V_bance (
    c_transakce INTEGER,
    c_uctu INTEGER
);

--Subtype Prevod
CREATE TABLE Mimo_banku (
    c_transakce INTEGER,
    c_uctu INTEGER,
    proti_c_banky INTEGER,
    proti_iban VARCHAR(255)
);

ALTER TABLE Klient ADD CONSTRAINT PK_klient PRIMARY KEY (r_cislo);
ALTER TABLE Ucet ADD CONSTRAINT PK_ucet PRIMARY KEY (c_uctu);
ALTER TABLE Ucet ADD CONSTRAINT FK_ucet_rcislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE Disponent ADD CONSTRAINT PK_disponent PRIMARY KEY (r_cislo, c_uctu);
ALTER TABLE Disponent ADD CONSTRAINT FK_disponent_rcislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE Disponent ADD CONSTRAINT FK_disponent_cuctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Operace ADD CONSTRAINT PK_operace PRIMARY KEY (c_uctu, c_transakce);
ALTER TABLE Operace ADD CONSTRAINT FK_operace_cuctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Vklad ADD CONSTRAINT PK_vklad PRIMARY KEY (c_uctu, c_transakce);
ALTER TABLE Vklad ADD CONSTRAINT FK_vklad_c_transakce FOREIGN KEY (c_uctu, c_transakce) REFERENCES Operace(c_uctu, c_transakce) ON DELETE CASCADE;
ALTER TABLE Vklad ADD CONSTRAINT FK_vklad_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Vyber ADD CONSTRAINT PK_vyber PRIMARY KEY (c_uctu, c_transakce);
ALTER TABLE Vyber ADD CONSTRAINT FK_vyber_c_transakce FOREIGN KEY (c_uctu, c_transakce) REFERENCES Operace(c_uctu, c_transakce) ON DELETE CASCADE;
ALTER TABLE Vyber ADD CONSTRAINT FK_vyber_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Prevod ADD CONSTRAINT PK_prevod PRIMARY KEY (c_uctu, c_transakce);
ALTER TABLE Prevod ADD CONSTRAINT FK_prevod_c_transakce FOREIGN KEY (c_uctu, c_transakce) REFERENCES Operace(c_uctu, c_transakce) ON DELETE CASCADE;
ALTER TABLE Prevod ADD CONSTRAINT FK_prevod_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE V_bance ADD CONSTRAINT PK_v_bance PRIMARY KEY (c_uctu, c_transakce);
ALTER TABLE V_bance ADD CONSTRAINT FK_v_bance_c_transakce FOREIGN KEY (c_uctu, c_transakce) REFERENCES Prevod(c_uctu, c_transakce) ON DELETE CASCADE;
ALTER TABLE V_bance ADD CONSTRAINT FK_v_bance_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Mimo_banku ADD CONSTRAINT PK_mimo_banku PRIMARY KEY (c_uctu, c_transakce);
ALTER TABLE Mimo_banku ADD CONSTRAINT FK_mimo_banku_c_transakce FOREIGN KEY (c_uctu, c_transakce) REFERENCES Prevod(c_uctu, c_transakce) ON DELETE CASCADE;
ALTER TABLE Mimo_banku ADD CONSTRAINT FK_mimo_banku_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;

INSERT INTO Klient VALUES('440726/0672', 'Jan', 'Novak', 'Cejl 8, Brno', '+420 123 456 789', 'jannovak@gmail.com');
INSERT INTO Klient VALUES('530610/4532', 'Petr', 'Vesely', 'Podzimni 28, Brno', '+420 918 521 341', 'petrvesely12@azet.sk');
INSERT INTO Klient VALUES('601001/2218', 'Ivan', 'Zeman ', 'Cejl 8, Brno', '+420 123 451 142', 'zeman99@seznam.cz');
INSERT INTO Klient VALUES('510230/0482', 'Pavel', 'Tomek', 'Tomkova 34, Brno', '+420 523 816 199', 'ptomek1@gmail.com');
INSERT INTO Klient VALUES('580807/9638', 'Josef', 'Madr', 'Svatoplukova 15, Brno', '+420 881 989 234', 'josef.madr@gmail.com');
INSERT INTO Klient VALUES('625622/6249', 'Jana', 'Mala', 'Brnenska 56, Vyskov', '+420 345 215 968', 'malajana@gmail.com');

INSERT INTO Ucet VALUES(4320271, '440726/0672', 52000, 0800, 000000, 'CZ94 0800 0000 0000 0432 0271');
INSERT INTO Ucet VALUES(2348537, '530610/4532', 10000, 0800, 000000, 'CZ14 0800 0000 0000 0234 8537');
INSERT INTO Ucet VALUES(2075751, '440726/0672', 26350, 0300, 000000, 'CZ13 0300 0000 0000 0207 5751');
INSERT INTO Ucet VALUES(1182643, '530610/4532', 10853, 0300, 000035, 'CZ81 0300 0000 3500 0118 2643');

INSERT INTO Operace VALUES(1, 4320271, TO_TIMESTAMP('10-10-2016 14:10:10.123000','DD-MM-RRRR HH24:MI:SS.FF'), 30000);
INSERT INTO Operace VALUES(2, 4320271, TO_TIMESTAMP('17-03-2017 12:30:53.123000','DD-MM-RRRR HH24:MI:SS.FF'), 5000);
INSERT INTO Operace VALUES(1, 2075751, TO_TIMESTAMP('11-12-2016 08:56:30.123000','DD-MM-RRRR HH24:MI:SS.FF'), 2000);
INSERT INTO Operace VALUES(2, 2075751, TO_TIMESTAMP('01-01-2018 09:02:22.123000','DD-MM-RRRR HH24:MI:SS.FF'), 10000);

INSERT INTO Vklad VALUES(1, 4320271, 'banka');
INSERT INTO Vyber VALUES(1, 2075751, 'bankomat');
INSERT INTO Prevod VALUES(2, 2075751, 1182643, 000035);
INSERT INTO Prevod VALUES(2, 4320271, 2075751, 000000);
INSERT INTO V_bance VALUES(2, 2075751);
INSERT INTO Mimo_banku VALUES(2, 4320271, 0300, 'CZ13 0300 0000 0000 0207 5751');

INSERT INTO Disponent VALUES('530610/4532', 4320271);
INSERT INTO Disponent VALUES('510230/0482', 4320271);
INSERT INTO Disponent VALUES('510230/0482', 2075751);
INSERT INTO Disponent VALUES('601001/2218', 2348537);
INSERT INTO Disponent VALUES('625622/6249', 2348537);

--TODO CHECK c_uctu, r_cislo
--TODO generate NULL values

COMMIT;

SELECT * FROM Klient;
SELECT * FROM Ucet;
SELECT * FROM Disponent;
SELECT * FROM Operace;
SELECT * FROM Vklad;
SELECT * FROM Vyber;
SELECT * FROM Prevod;
SELECT * FROM V_bance;
SELECT * FROM Mimo_banku;
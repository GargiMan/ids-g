-- Banka

------------------------------------------------------------
---------------------------TABLES---------------------------
------------------------------------------------------------

-- Drop all tables
BEGIN
    FOR i IN (SELECT table_name FROM user_tables) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ' || i.table_name || ' CASCADE CONSTRAINTS PURGE';
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE != -942 AND SQLCODE != -12083 THEN -- -942 = table does not exist, -12083 = drop materialized view
                    RAISE;
                END IF;
        END;
    END LOOP;
END;

--Entity
CREATE TABLE Klient (
    r_cislo CHAR(11) NOT NULL,
    jmeno VARCHAR(255),
    prijmeni VARCHAR(255),
    adresa VARCHAR(255),
    telefon VARCHAR(255),
    email VARCHAR(255),
    pohlavi VARCHAR(255)
);

--Entity
CREATE TABLE Ucet (
    c_uctu NUMBER(10),
    r_cislo CHAR(11) NOT NULL,
    stav DECIMAL(10,2) DEFAULT 0,
    c_banky NUMBER(4),
    predcisli NUMBER(6) DEFAULT 0
);

--Klient_Ucet many to many relationship
CREATE TABLE Disponent (
    r_cislo CHAR(11) NOT NULL,
    c_uctu NUMBER(10) NOT NULL
);

--Entity
CREATE TABLE Operace (
    c_operace INTEGER,
    c_uctu NUMBER(10) NOT NULL,
    r_cislo CHAR(11) NOT NULL,
    datum_cas TIMESTAMP DEFAULT TO_TIMESTAMP(SYSDATE,'DD-MM-RRRR HH24:MI:SS.FF'),
    castka DECIMAL(10,2) NOT NULL,
    provedl VARCHAR(255)
);

--Subtype of Operace
CREATE TABLE Vklad (
    c_operace INTEGER,
    c_uctu NUMBER(10) NOT NULL,
    r_cislo CHAR(11) NOT NULL,
    datum_cas TIMESTAMP DEFAULT TO_TIMESTAMP(SYSDATE,'DD-MM-RRRR HH24:MI:SS.FF'),
    castka DECIMAL(10,2) NOT NULL,
    provedl VARCHAR(255) DEFAULT 'System'
);

--Subtype of Operace
CREATE TABLE Vyber (
    c_operace INTEGER,
    c_uctu NUMBER(10) NOT NULL,
    r_cislo CHAR(11) NOT NULL,
    datum_cas TIMESTAMP DEFAULT TO_TIMESTAMP(SYSDATE,'DD-MM-RRRR HH24:MI:SS.FF'),
    castka DECIMAL(10,2) NOT NULL,
    provedl VARCHAR(255) DEFAULT 'System'
);

--Subtype of Operace
CREATE TABLE Prevod (
    c_operace INTEGER,
    c_uctu NUMBER(10) NOT NULL,
    r_cislo CHAR(11) NOT NULL,
    datum_cas TIMESTAMP DEFAULT TO_TIMESTAMP(SYSDATE,'DD-MM-RRRR HH24:MI:SS.FF'),
    castka DECIMAL(10,2) NOT NULL,
    provedl VARCHAR(255) DEFAULT 'System',
    proti_predcisli NUMBER(6) DEFAULT 0,
    proti_c_uctu NUMBER(10) NOT NULL
);

--Subtype of Prevod
CREATE TABLE V_bance (
    c_operace INTEGER,
    c_uctu NUMBER(10) NOT NULL,
    r_cislo CHAR(11) NOT NULL,
    datum_cas TIMESTAMP DEFAULT TO_TIMESTAMP(SYSDATE,'DD-MM-RRRR HH24:MI:SS.FF'),
    castka DECIMAL(10,2) NOT NULL,
    provedl VARCHAR(255) DEFAULT 'System',
    proti_predcisli NUMBER(6) DEFAULT 0,
    proti_c_uctu NUMBER(10) NOT NULL
);

--Subtype of Prevod
CREATE TABLE Mimo_banku (
    c_operace INTEGER,
    c_uctu NUMBER(10) NOT NULL,
    r_cislo CHAR(11) NOT NULL,
    datum_cas TIMESTAMP DEFAULT TO_TIMESTAMP(SYSDATE,'DD-MM-RRRR HH24:MI:SS.FF'),
    castka DECIMAL(10,2) NOT NULL,
    provedl VARCHAR(255) DEFAULT 'System',
    proti_predcisli NUMBER(6) DEFAULT 0,
    proti_c_uctu NUMBER(10) NOT NULL,
    proti_c_banky NUMBER(4) NOT NULL
);

-- Validate account number
ALTER TABLE Ucet ADD CHECK (c_uctu > 0 AND MOD((MOD(c_uctu,10)*1 + MOD(FLOOR(c_uctu/10),10)*2 + MOD(FLOOR(c_uctu/100),10)*4 +
    MOD(FLOOR(c_uctu/1000),10)*8 + MOD(FLOOR(c_uctu/10000),10)*5 + MOD(FLOOR(c_uctu/100000),10)*10 + MOD(FLOOR(c_uctu/1000000),10)*9 +
    MOD(FLOOR(c_uctu/10000000),10)*7 + MOD(FLOOR(c_uctu/100000000),10)*3 + MOD(FLOOR(c_uctu/1000000000),10)*6),11) = 0);
ALTER TABLE Ucet ADD CHECK (MOD((MOD(predcisli,10)*1 + MOD(FLOOR(predcisli/10),10)*2 + MOD(FLOOR(predcisli/100),10)*4 +
    MOD(FLOOR(predcisli/1000),10)*8 + MOD(FLOOR(predcisli/10000),10)*5 + MOD(FLOOR(predcisli/100000),10)*10),11) = 0);
ALTER TABLE Prevod ADD CHECK (proti_c_uctu > 0 AND MOD((MOD(proti_c_uctu,10)*1 + MOD(FLOOR(proti_c_uctu/10),10)*2 + MOD(FLOOR(proti_c_uctu/100),10)*4 +
    MOD(FLOOR(proti_c_uctu/1000),10)*8 + MOD(FLOOR(proti_c_uctu/10000),10)*5 + MOD(FLOOR(proti_c_uctu/100000),10)*10 + MOD(FLOOR(proti_c_uctu/1000000),10)*9 +
    MOD(FLOOR(proti_c_uctu/10000000),10)*7 + MOD(FLOOR(proti_c_uctu/100000000),10)*3 + MOD(FLOOR(proti_c_uctu/1000000000),10)*6),11) = 0);
ALTER TABLE Prevod ADD CHECK (MOD((MOD(proti_predcisli,10)*1 + MOD(FLOOR(proti_predcisli/10),10)*2 + MOD(FLOOR(proti_predcisli/100),10)*4 +
    MOD(FLOOR(proti_predcisli/1000),10)*8 + MOD(FLOOR(proti_predcisli/10000),10)*5 + MOD(FLOOR(proti_predcisli/100000),10)*10),11) = 0);

-- Add constraints
ALTER TABLE Klient ADD CONSTRAINT PK_klient PRIMARY KEY (r_cislo);
ALTER TABLE Ucet ADD CONSTRAINT PK_ucet PRIMARY KEY (c_uctu);
ALTER TABLE Ucet ADD CONSTRAINT FK_ucet_r_cislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE Disponent ADD CONSTRAINT PK_disponent PRIMARY KEY (r_cislo, c_uctu);
ALTER TABLE Disponent ADD CONSTRAINT FK_disponent_r_cislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE Disponent ADD CONSTRAINT FK_disponent_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Operace ADD CONSTRAINT PK_operace PRIMARY KEY (c_uctu, c_operace);
ALTER TABLE Operace ADD CONSTRAINT FK_operace_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Operace ADD CONSTRAINT FK_operace_r_cislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE Vklad ADD CONSTRAINT PK_vklad PRIMARY KEY (c_uctu, c_operace);
ALTER TABLE Vklad ADD CONSTRAINT FK_vklad_c_operace FOREIGN KEY (c_uctu, c_operace) REFERENCES Operace(c_uctu, c_operace) ON DELETE CASCADE;
ALTER TABLE Vklad ADD CONSTRAINT FK_vklad_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Vklad ADD CONSTRAINT FK_vklad_r_cislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE Vyber ADD CONSTRAINT PK_vyber PRIMARY KEY (c_uctu, c_operace);
ALTER TABLE Vyber ADD CONSTRAINT FK_vyber_c_operace FOREIGN KEY (c_uctu, c_operace) REFERENCES Operace(c_uctu, c_operace) ON DELETE CASCADE;
ALTER TABLE Vyber ADD CONSTRAINT FK_vyber_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Vyber ADD CONSTRAINT FK_vyber_r_cislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE Prevod ADD CONSTRAINT PK_prevod PRIMARY KEY (c_uctu, c_operace);
ALTER TABLE Prevod ADD CONSTRAINT FK_prevod_c_operace FOREIGN KEY (c_uctu, c_operace) REFERENCES Operace(c_uctu, c_operace) ON DELETE CASCADE;
ALTER TABLE Prevod ADD CONSTRAINT FK_prevod_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Prevod ADD CONSTRAINT FK_prevod_r_cislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE V_bance ADD CONSTRAINT PK_v_bance PRIMARY KEY (c_uctu, c_operace);
ALTER TABLE V_bance ADD CONSTRAINT FK_v_bance_c_operace FOREIGN KEY (c_uctu, c_operace) REFERENCES Prevod(c_uctu, c_operace) ON DELETE CASCADE;
ALTER TABLE V_bance ADD CONSTRAINT FK_v_bance_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE V_bance ADD CONSTRAINT FK_v_bance_r_cislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;
ALTER TABLE Mimo_banku ADD CONSTRAINT PK_mimo_banku PRIMARY KEY (c_uctu, c_operace);
ALTER TABLE Mimo_banku ADD CONSTRAINT FK_mimo_banku_c_operace FOREIGN KEY (c_uctu, c_operace) REFERENCES Prevod(c_uctu, c_operace) ON DELETE CASCADE;
ALTER TABLE Mimo_banku ADD CONSTRAINT FK_mimo_banku_c_uctu FOREIGN KEY (c_uctu) REFERENCES Ucet(c_uctu) ON DELETE CASCADE;
ALTER TABLE Mimo_banku ADD CONSTRAINT FK_mimo_banku_r_cislo FOREIGN KEY (r_cislo) REFERENCES Klient(r_cislo) ON DELETE CASCADE;

------------------------------------------------------------
------------------PROCEDURES-AND-FUNCTIONS------------------
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE show_statement_for_random_account AS
    TYPE account_numbers_t IS TABLE OF Ucet.c_uctu%TYPE;
    account_numbers account_numbers_t;
    random_index NUMBER;
    random_account_number Ucet.c_uctu%TYPE;
    account_stav Ucet.stav%TYPE;
    transaction_record Operace%ROWTYPE;
    transaction_id_vyber Vklad.c_operace%TYPE;
    transaction_id_vklad Vyber.c_operace%TYPE;
    transaction_id_v_bance V_bance.c_operace%TYPE;
    transaction_id_mimo_banku Mimo_banku.c_operace%TYPE;
    CURSOR account_cursor IS SELECT c_uctu FROM Ucet;
    CURSOR account_cursor_stav IS SELECT stav FROM Ucet WHERE c_uctu = random_account_number;
    CURSOR transaction_cursor IS SELECT * FROM Operace WHERE c_uctu = random_account_number;
    CURSOR transaction_cursor_vyber IS SELECT c_operace FROM Vyber WHERE c_uctu = random_account_number AND c_operace = transaction_record.c_operace;
    CURSOR transaction_cursor_vklad IS SELECT c_operace FROM Vklad WHERE c_uctu = random_account_number AND c_operace = transaction_record.c_operace;
    CURSOR transaction_cursor_v_bance IS SELECT c_operace FROM V_bance WHERE c_uctu = random_account_number AND c_operace = transaction_record.c_operace;
    CURSOR transaction_cursor_mimo_banku IS SELECT c_operace FROM Mimo_banku WHERE c_uctu = random_account_number AND c_operace = transaction_record.c_operace;
BEGIN
    DBMS_OUTPUT.PUT_LINE('---------------------------------');

    OPEN account_cursor;
    FETCH account_cursor BULK COLLECT INTO account_numbers;
    CLOSE account_cursor;

    random_index := DBMS_RANDOM.VALUE(1, account_numbers.COUNT);
    random_account_number := account_numbers(TRUNC(random_index));

    OPEN account_cursor_stav;
    FETCH account_cursor_stav INTO account_stav;
    CLOSE account_cursor_stav;

    DBMS_OUTPUT.PUT_LINE('Transactions for account: ' || random_account_number);
    DBMS_OUTPUT.PUT_LINE('Current balance: ' || account_stav || ' CZK');
    DBMS_OUTPUT.PUT_LINE('---------------------------------');

    OPEN transaction_cursor;
    OPEN transaction_cursor_vyber;
    OPEN transaction_cursor_vklad;
    OPEN transaction_cursor_v_bance;
    OPEN transaction_cursor_mimo_banku;

    LOOP
        FETCH transaction_cursor INTO transaction_record;
        EXIT WHEN transaction_cursor%NOTFOUND;
        FETCH transaction_cursor_vyber INTO transaction_id_vyber;
        FETCH transaction_cursor_vklad INTO transaction_id_vklad;
        FETCH transaction_cursor_v_bance INTO transaction_id_v_bance;
        FETCH transaction_cursor_mimo_banku INTO transaction_id_mimo_banku;
        CASE
            WHEN transaction_record.c_operace = transaction_id_vklad THEN
                DBMS_OUTPUT.PUT_LINE(transaction_record.datum_cas || ':  Deposit ' || transaction_record.castka);
            WHEN transaction_record.c_operace = transaction_id_vyber THEN
                DBMS_OUTPUT.PUT_LINE(transaction_record.datum_cas || ':  Withdrawal ' || transaction_record.castka);
            WHEN transaction_record.c_operace = transaction_id_v_bance THEN
                DBMS_OUTPUT.PUT_LINE(transaction_record.datum_cas || ':  Transfer ' || transaction_record.castka);
            WHEN transaction_record.c_operace = transaction_id_mimo_banku THEN
                DBMS_OUTPUT.PUT_LINE(transaction_record.datum_cas || ':  Transfer ' || transaction_record.castka);
        END CASE;
    END LOOP;
    CLOSE transaction_cursor;
    CLOSE transaction_cursor_vyber;
    CLOSE transaction_cursor_vklad;
    CLOSE transaction_cursor_v_bance;
    CLOSE transaction_cursor_mimo_banku;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

CREATE OR REPLACE PROCEDURE generate_account_number(c_uctu_out OUT NUMBER) AS
    v_count NUMBER;
BEGIN
    LOOP
        c_uctu_out := FLOOR(DBMS_RANDOM.VALUE * 10000000000);

        IF MOD((MOD(c_uctu_out,10)*1 + MOD(FLOOR(c_uctu_out/10),10)*2 + MOD(FLOOR(c_uctu_out/100),10)*4 +
            MOD(FLOOR(c_uctu_out/1000),10)*8 + MOD(FLOOR(c_uctu_out/10000),10)*5 + MOD(FLOOR(c_uctu_out/100000),10)*10 + MOD(FLOOR(c_uctu_out/1000000),10)*9 +
            MOD(FLOOR(c_uctu_out/10000000),10)*7 + MOD(FLOOR(c_uctu_out/100000000),10)*3 + MOD(FLOOR(c_uctu_out/1000000000),10)*6),11) = 0 THEN

            SELECT COUNT(*) INTO v_count FROM Ucet WHERE c_uctu = c_uctu_out;
            IF v_count = 0 THEN
                RETURN;
            END IF;
        END IF;
    END LOOP;
END;

CREATE OR REPLACE PROCEDURE check_accounts_are_in_same_bank(c_uctu_in IN INTEGER, proti_predcisli_in IN INTEGER, proti_c_uctu_in IN INTEGER) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Ucet WHERE c_banky = (SELECT Ucet.c_banky FROM Ucet WHERE Ucet.c_uctu = c_uctu_in) AND predcisli = proti_predcisli_in AND c_uctu = proti_c_uctu_in;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Bank accounts are not in the same bank.');
    END IF;
END;

CREATE OR REPLACE PROCEDURE check_client_has_access_to_account(r_cislo_in IN CHAR, c_uctu_in IN INTEGER) AS
    v_count_1 NUMBER;
    v_count_2 NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count_1 FROM Ucet WHERE Ucet.r_cislo = r_cislo_in AND Ucet.c_uctu = c_uctu_in;
    SELECT COUNT(*) INTO v_count_2 FROM Disponent WHERE Disponent.r_cislo = r_cislo_in AND Disponent.c_uctu = c_uctu_in;
    IF v_count_1 = 0 AND v_count_2 = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Client does not have access to account.');
    END IF;
END;

CREATE OR REPLACE FUNCTION get_index_of_next_operation(c_uctu_in IN INTEGER) RETURN INTEGER AS
    max_index NUMBER;
BEGIN
    SELECT COALESCE(MAX(c_operace), 0) + 1 INTO max_index FROM Operace WHERE c_uctu = c_uctu_in;
    RETURN max_index;
END;

------------------------------------------------------------
--------------------------TRIGGERS--------------------------
------------------------------------------------------------

CREATE OR REPLACE TRIGGER trig_insert_klient
BEFORE INSERT ON Klient
FOR EACH ROW
BEGIN
    IF substr(:NEW.r_cislo, 3, 1) < 5 THEN
        :NEW.pohlavi := 'muz';
    ELSE
        :NEW.pohlavi := 'zena';
    END IF;
END;

CREATE OR REPLACE TRIGGER trig_insert_ucet
BEFORE INSERT ON Ucet
FOR EACH ROW
BEGIN
    IF :NEW.c_uctu IS NULL THEN
       generate_account_number(:NEW.c_uctu);
    END IF;
END;

CREATE OR REPLACE TRIGGER trig_insert_operace
BEFORE INSERT ON Operace
FOR EACH ROW
BEGIN
    check_client_has_access_to_account(:NEW.r_cislo, :NEW.c_uctu);
END;

CREATE OR REPLACE TRIGGER trig_insert_vklad
BEFORE INSERT ON Vklad
FOR EACH ROW
BEGIN
    :NEW.c_operace := get_index_of_next_operation(:NEW.c_uctu);

    -- Copy values to super tables
    INSERT INTO Operace VALUES (:NEW.c_operace, :NEW.c_uctu, :NEW.r_cislo, :NEW.datum_cas, :NEW.castka, :NEW.provedl);

    -- Update account balance
    UPDATE Ucet SET stav = stav + :NEW.castka WHERE c_uctu = :NEW.c_uctu;
END;

CREATE OR REPLACE TRIGGER trig_insert_vyber
BEFORE INSERT ON Vyber
FOR EACH ROW
BEGIN
    :NEW.c_operace := get_index_of_next_operation(:NEW.c_uctu);

    -- Copy values to super tables
    INSERT INTO Operace VALUES (:NEW.c_operace, :NEW.c_uctu, :NEW.r_cislo, :NEW.datum_cas, :NEW.castka, :NEW.provedl);

    -- Update account balance
    UPDATE Ucet SET stav = stav - :NEW.castka WHERE c_uctu = :NEW.c_uctu;
END;

CREATE OR REPLACE TRIGGER trig_insert_mimo_banku
BEFORE INSERT ON Mimo_banku
FOR EACH ROW
BEGIN
    :NEW.c_operace := get_index_of_next_operation(:NEW.c_uctu);

    -- Copy values to super tables
    INSERT INTO Operace VALUES (:NEW.c_operace, :NEW.c_uctu, :NEW.r_cislo, :NEW.datum_cas, :NEW.castka, :NEW.provedl);
    INSERT INTO Prevod VALUES (:NEW.c_operace, :NEW.c_uctu, :NEW.r_cislo, :NEW.datum_cas, :NEW.castka, :NEW.provedl, :NEW.proti_predcisli, :NEW.proti_c_uctu);

    -- Update accounts balance
    UPDATE Ucet SET stav = stav - :NEW.castka WHERE c_uctu = :NEW.c_uctu;
    UPDATE Ucet SET stav = stav + :NEW.castka WHERE c_uctu = :NEW.proti_c_uctu;
END;

CREATE OR REPLACE TRIGGER trig_insert_v_bance
BEFORE INSERT ON V_bance
FOR EACH ROW
BEGIN
    check_accounts_are_in_same_bank(:NEW.c_uctu, :NEW.proti_predcisli, :NEW.proti_c_uctu);
    :NEW.c_operace := get_index_of_next_operation(:NEW.c_uctu);

    -- Copy values to super tables
    INSERT INTO Operace VALUES (:NEW.c_operace, :NEW.c_uctu, :NEW.r_cislo, :NEW.datum_cas, :NEW.castka, :NEW.provedl);
    INSERT INTO Prevod VALUES (:NEW.c_operace, :NEW.c_uctu, :NEW.r_cislo, :NEW.datum_cas, :NEW.castka, :NEW.provedl, :NEW.proti_predcisli, :NEW.proti_c_uctu);

    -- Update accounts balance
    UPDATE Ucet SET stav = stav - :NEW.castka WHERE c_uctu = :NEW.c_uctu;
    UPDATE Ucet SET stav = stav + :NEW.castka WHERE c_uctu = :NEW.proti_c_uctu;
END;

------------------------------------------------------------
------------------------INSERT-DATA-------------------------
------------------------------------------------------------

INSERT INTO Klient(r_cislo, jmeno, prijmeni, adresa, telefon, email) VALUES('440726/0672', 'Jan', 'Novak', 'Cejl 8, Brno', '+420 123 456 789', 'jannovak@gmail.com');
INSERT INTO Klient(r_cislo, jmeno, prijmeni, adresa, telefon, email) VALUES('530610/4532', 'Petr', 'Vesely', 'Podzimni 28, Brno', '+420 918 521 341', 'petrvesely12@azet.sk');
INSERT INTO Klient(r_cislo, jmeno, prijmeni, adresa, telefon, email) VALUES('601001/2218', 'Ivan', 'Pavel ', 'Cejl 8, Brno', '+420 123 451 142', 'pavel99@seznam.cz');
INSERT INTO Klient(r_cislo, jmeno, prijmeni, adresa, telefon, email) VALUES('510230/0482', 'Pavel', 'Tomek', 'Tomkova 34, Brno', '+420 523 816 199', 'ptomek1@gmail.com');
INSERT INTO Klient(r_cislo, jmeno, prijmeni, adresa, telefon, email) VALUES('580807/9638', 'Josef', 'Madr', 'Svatoplukova 15, Brno', '+420 881 989 234', 'josef.madr@gmail.com');
INSERT INTO Klient(r_cislo, jmeno, prijmeni, adresa, telefon, email) VALUES('625622/6249', 'Jana', 'Mala', 'Brnenska 56, Vyskov', '+420 345 215 968', 'malajana@gmail.com');

INSERT INTO Ucet VALUES(4320271, '440726/0672', 52000, 0800, 000000);
INSERT INTO Ucet VALUES(2348537, '530610/4532', 10000, 0800, 000000);
INSERT INTO Ucet VALUES(2075751, '625622/6249', 26350, 0300, 000000);
INSERT INTO Ucet VALUES(1182643, '530610/4532', 10853, 0300, 000035);

INSERT INTO Disponent VALUES('530610/4532', 4320271);
INSERT INTO Disponent VALUES('510230/0482', 4320271);
INSERT INTO Disponent VALUES('510230/0482', 2075751);
INSERT INTO Disponent VALUES('601001/2218', 2348537);
INSERT INTO Disponent VALUES('625622/6249', 2348537);

-- Insert operations (Vklad, Vyber, Prevod, V_bance, Mimo_banku)
-- Operations should be only inserted to subtype tables and triggers will copy them to super tables
INSERT INTO Vklad (c_uctu, r_cislo, datum_cas, castka, provedl)
VALUES(4320271, '440726/0672', TO_TIMESTAMP('10-10-2016 14:10:10.123000','DD-MM-RRRR HH24:MI:SS.FF'), 30000, 'Daniel Starý');
INSERT INTO Vklad (c_uctu, r_cislo, datum_cas, castka, provedl)
VALUES(2348537, '530610/4532', TO_TIMESTAMP('02-05-2015 20:00:22.123000','DD-MM-RRRR HH24:MI:SS.FF'), 10000, 'Daniel Starý');
INSERT INTO Vyber (c_uctu, r_cislo, datum_cas, castka, provedl)
VALUES(2075751, '510230/0482', TO_TIMESTAMP('11-12-2016 08:56:30.123000','DD-MM-RRRR HH24:MI:SS.FF'), 2000, 'Petra Silná');
INSERT INTO Vyber (c_uctu, r_cislo, datum_cas, castka, provedl)
VALUES(4320271, '530610/4532', TO_TIMESTAMP('22-07-2017 13:33:15.123000','DD-MM-RRRR HH24:MI:SS.FF'), 8000, 'Daniel Starý');
INSERT INTO V_bance (c_uctu, r_cislo, datum_cas, castka, provedl, proti_predcisli, proti_c_uctu)
VALUES(2075751, '625622/6249', TO_TIMESTAMP('01-01-2018 09:02:22.123000','DD-MM-RRRR HH24:MI:SS.FF'), 10000, 'Petra Silná', 000035, 1182643);
INSERT INTO V_bance (c_uctu, r_cislo, datum_cas, castka, provedl, proti_predcisli, proti_c_uctu)
VALUES(2348537, '601001/2218', TO_TIMESTAMP('28-11-2020 15:55:41.123000','DD-MM-RRRR HH24:MI:SS.FF'), 6000, 'Daniel Starý', 000000, 4320271);
INSERT INTO Mimo_banku (c_uctu, r_cislo, datum_cas, castka, provedl, proti_predcisli, proti_c_uctu, proti_c_banky)
VALUES(4320271, '440726/0672', TO_TIMESTAMP('17-03-2017 12:30:53.123000','DD-MM-RRRR HH24:MI:SS.FF'), 5000, 'Daniel Starý', 000000, 2075751, 0300);
INSERT INTO Mimo_banku (c_uctu, r_cislo, datum_cas, castka, provedl, proti_predcisli, proti_c_uctu, proti_c_banky)
VALUES(2075751, '510230/0482', TO_TIMESTAMP('30-08-2021 16:36:34.123000','DD-MM-RRRR HH24:MI:SS.FF'), 1000, 'Petra Silná', 000000, 2348537, 0800);

-- OTHER INSERTS CHECKING FUNCTIONALITY
/*
-- Not existing bank account
INSERT INTO Vklad (c_uctu, r_cislo, datum_cas, castka, provedl)
VALUES(4320270, '440726/0672', TO_TIMESTAMP('10-10-2016 14:10:10.123000','DD-MM-RRRR HH24:MI:SS.FF'), 3000, 'Daniel Starý');

-- Index of operation would be replaced
INSERT INTO Vyber
VALUES(9999, 4320271, '440726/0672', TO_TIMESTAMP('10-10-2016 14:10:12.123000','DD-MM-RRRR HH24:MI:SS.FF'), 3000, 'Daniel Starý');

-- Accounts are not in the same bank
INSERT INTO V_bance (c_uctu, r_cislo, datum_cas, castka, provedl, proti_predcisli, proti_c_uctu)
VALUES(2348537, '601001/2218', TO_TIMESTAMP('28-11-2020 15:55:41.123000','DD-MM-RRRR HH24:MI:SS.FF'), 6000, 'Daniel Starý', 000000, 2075751);

-- Client does not have access to account
INSERT INTO Vklad (c_uctu, r_cislo, datum_cas, castka, provedl)
VALUES(4320271, '601001/2218', TO_TIMESTAMP('10-10-2016 14:10:10.123000','DD-MM-RRRR HH24:MI:SS.FF'), 3000, 'Daniel Starý');

-- Account number was not specified
INSERT INTO Ucet
VALUES(NULL, '601001/2218', 10000, 0800, 000000);

-- Client gender was not specified
INSERT INTO Klient(r_cislo)
VALUES('896226/0672');
*/
COMMIT;

------------------------------------------------------------
---------SELECT-DATA---INDEX---EXPLAIN-TABLE----------------
------------------------------------------------------------

-- SHOW TABLE DATA
SELECT * FROM Klient;
SELECT * FROM Ucet;
SELECT * FROM Disponent;
SELECT * FROM Operace;
SELECT * FROM Vklad;
SELECT * FROM Vyber;
SELECT * FROM Prevod;
SELECT * FROM V_bance;
SELECT * FROM Mimo_banku;

--Kteri klienti maji alespon 20 000 na ucte.
SELECT  r_cislo, jmeno, prijmeni, stav
FROM Klient NATURAL JOIN Ucet
WHERE stav > 20000;

--Kteri klienti jsou i disponentem.
SELECT DISTINCT jmeno, prijmeni, r_cislo
FROM Disponent NATURAL JOIN Klient
WHERE jmeno LIKE '%';

--Klienti kteri jsou disponentem alespon jednoho uctu, na kterem je pres 30 000.
SELECT  DISTINCT jmeno, prijmeni, K.r_cislo
FROM Klient K, Disponent D, Ucet U
WHERE K.r_cislo=D.r_cislo AND D.C_UCTU = U.C_UCTU AND U.stav>30000;

--Kteri klienti odeslali nejvic penez pryc z banky.
SELECT jmeno, prijmeni, r_cislo, SUM(castka)
FROM Klient NATURAL JOIN Mimo_banku
GROUP BY jmeno, prijmeni, r_cislo
ORDER BY SUM(castka) DESC;

--Show all transactions for random account
BEGIN
    show_statement_for_random_account;
END;


--Categorize clients by their balance
SELECT DISTINCT jmeno, prijmeni, SUM(stav) celkem, CASE
               WHEN SUM(stav) < 10000 THEN 'Low balance'
               WHEN SUM(stav) < 50000 THEN 'Medium balance'
               ELSE 'High balance'
    END AS balance_category FROM Ucet NATURAL JOIN Klient
GROUP BY jmeno, prijmeni;

------------------------Explain plan--------------------------
--Kolik maji celkove penez jednotlivi klienti na svych uctech.
EXPLAIN PLAN FOR
    SELECT jmeno, prijmeni, r_cislo, SUM(stav) celkem
    FROM Klient NATURAL JOIN Ucet
    GROUP BY jmeno, prijmeni, r_cislo
    ORDER BY celkem DESC;

--Ukaz posledne vytvoreny exlain plan
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

--Kteri klienti uz nekdy prevedli penize.
SELECT jmeno, prijmeni, r_cislo
FROM Klient NATURAL JOIN Prevod
WHERE EXISTS
          (SELECT jmeno, prijmeni, r_cislo
           FROM Klient NATURAL JOIN Prevod
           WHERE castka > 0);

--Kteri klienti jsou disponentem vice nez jednoho uctu.
SELECT jmeno, prijmeni, r_cislo
FROM Klient
WHERE r_cislo IN (SELECT D.R_CISLO FROM Klient K, DISPONENT D
                WHERE K.R_CISLO = D.R_CISLO
                group by K.R_CISLO
                having COUNT(*)>1);



--------------------------- Index --------------------------
--agregační funkce = SUM(stav), GROUP BY je tam taky, spojeni Klienta a uctu.
--Index na klienta, pri hledani transakci v bance se obvykle potrebuje zjistit kdo a pro koho je transakce.
--Pouzitim tohoto indexu se snizilo maximalni vitizeni procesoru o 6% z 40% na 34%, pocet operaci o 2,
--pocet max dat k operaci ze 4 operaci, kazde vyuzivajicich 1188 bytu na 3 operace, kazde vyuzivajicich 147 bytu
--cas se v sekundach nezmenil (pod 1s)
--Dale urychlit pouzitim indexu na tabulku Ucet.

-- Drop index
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX jmena';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1418 THEN -- -1418 = index does not exist
            RAISE;
        END IF;
END;

CREATE INDEX jmena
ON Klient (jmeno, prijmeni, r_cislo);

EXPLAIN PLAN FOR
    SELECT jmeno, prijmeni, r_cislo, SUM(stav) celkem
    FROM Klient NATURAL JOIN Ucet
    GROUP BY jmeno, prijmeni, r_cislo
    ORDER BY celkem DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/* WITHOUT INDEX
-------------------------------------------------------------------------------------------
| Id  | Operation                     | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |           |     4 |  1188 |     5  (40)| 00:00:01 |
|   1 |  SORT ORDER BY                |           |     4 |  1188 |     5  (40)| 00:00:01 |
|   2 |   NESTED LOOPS                |           |     4 |  1188 |     4  (25)| 00:00:01 |
|   3 |    NESTED LOOPS               |           |     4 |  1188 |     4  (25)| 00:00:01 |
|   4 |     VIEW                      | VW_GBC_5  |     4 |   104 |     4  (25)| 00:00:01 |
|   5 |      HASH GROUP BY            |           |     4 |   104 |     4  (25)| 00:00:01 |
|   6 |       TABLE ACCESS FULL       | UCET      |     4 |   104 |     3   (0)| 00:00:01 |
|*  7 |     INDEX UNIQUE SCAN         | PK_KLIENT |     1 |       |     0   (0)| 00:00:01 |
|   8 |    TABLE ACCESS BY INDEX ROWID| KLIENT    |     1 |   271 |     0   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

"   7 - access(""KLIENT"".""R_CISLO""=""ITEM_1"")"
*/

/* WITH INDEX
----------------------------------------------------------------------------------
| Id  | Operation             | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |          |     3 |   147 |     6  (34)| 00:00:01 |
|   1 |  SORT ORDER BY        |          |     3 |   147 |     6  (34)| 00:00:01 |
|*  2 |   HASH JOIN           |          |     3 |   147 |     5  (20)| 00:00:01 |
|   3 |    VIEW               | VW_GBC_5 |     3 |    75 |     4  (25)| 00:00:01 |
|   4 |     HASH GROUP BY     |          |     3 |    51 |     4  (25)| 00:00:01 |
|   5 |      TABLE ACCESS FULL| UCET     |     4 |    68 |     3   (0)| 00:00:01 |
|   6 |    INDEX FULL SCAN    | JMENA    |     6 |   144 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

"   2 - access(""KLIENT"".""R_CISLO""=""ITEM_1"")"
*/

------------------------------------------------------------
------------------------PERMISSIONS-------------------------
------------------------------------------------------------

-- Drop materialized view
BEGIN
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW mv';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -12003 THEN -- -12003 = materialized view does not exist
            RAISE;
        END IF;
END;

CREATE MATERIALIZED VIEW mv REFRESH COMPLETE ON COMMIT AS SELECT r_cislo AS vlastnik, c_uctu, predcisli, c_banky, stav FROM Ucet;

GRANT ALL ON mv TO XGERGE01;

-- When xgerge01 executes 'SELECT * FROM XKUNDR07.MV_1'
-- He can't see the data in the table, but he can see the data in the materialized view that can be updated by the owner of the materialized view.

-- Give all permissions to XGERGE01
-- GRANT ALL ON Klient TO XGERGE01;
-- GRANT ALL ON Ucet TO XGERGE01;
-- GRANT ALL ON Disponent TO XGERGE01;
-- GRANT ALL ON Vklad TO XGERGE01;
-- GRANT ALL ON Vyber TO XGERGE01;
-- GRANT ALL ON V_bance TO XGERGE01;
-- GRANT ALL ON Mimo_banku TO XGERGE01;
-- GRANT SELECT ON Prevod TO XGERGE01;
-- GRANT SELECT ON Operace TO XGERGE01;

-- Revoke all permissions from XGERGE01
-- REVOKE ALL ON Klient FROM XGERGE01;
-- REVOKE ALL ON Ucet FROM XGERGE01;
-- REVOKE ALL ON Disponent FROM XGERGE01;
-- REVOKE ALL ON Vklad FROM XGERGE01;
-- REVOKE ALL ON Vyber FROM XGERGE01;
-- REVOKE ALL ON V_bance FROM XGERGE01;
-- REVOKE ALL ON Mimo_banku FROM XGERGE01;
-- REVOKE SELECT ON Prevod FROM XGERGE01;
-- REVOKE SELECT ON Operace FROM XGERGE01;

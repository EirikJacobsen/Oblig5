DROP DATABASE IF EXISTS oblig3_5tabeller;
CREATE DATABASE oblig3_5tabeller CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oblig3_5tabeller;

-- ============================================
-- 1) Kunde
-- Adresser er flatet inn i denne tabellen for å få 5 tabeller totalt.
-- Telefonnummer er utelatt i denne varianten, siden flere telefonnumre
-- per kunde ellers ville krevd egen tabell.
-- ============================================
CREATE TABLE Kunde (
    KundeNr INT NOT NULL,
    Kundenavn VARCHAR(100) NOT NULL,
    KundeType VARCHAR(20) NOT NULL,
    KundeEpost VARCHAR(150),

    LeveringAdrGate VARCHAR(100),
    LeveringAdrGateNr VARCHAR(20),
    LeveringAdrPostNr CHAR(4),
    LeveringAdrPoststed VARCHAR(50),

    FakturaAdrGate VARCHAR(100),
    FakturaAdrGateNr VARCHAR(20),
    FakturaAdrPostNr CHAR(4),
    FakturaAdrPoststed VARCHAR(50),

    PRIMARY KEY (KundeNr)
);

-- ============================================
-- 2) Kundebehandler
-- ============================================
CREATE TABLE Kundebehandler (
    KundebehandlerID INT NOT NULL,
    KundebehandlerNavn VARCHAR(100) NOT NULL,
    KundebehandlerTlf VARCHAR(12),
    PRIMARY KEY (KundebehandlerID)
);

-- ============================================
-- 3) UtstyrsMal
-- Kategori er lagt inn direkte her for å få 5 tabeller totalt.
-- ============================================
CREATE TABLE UtstyrsMal (
    UtstyrsMal_ID INT NOT NULL,
    UtstyrsMerke VARCHAR(45) NOT NULL,
    UtstyrsModell VARCHAR(45) NOT NULL,
    UtstyrsType VARCHAR(45) NOT NULL,
    Kategori VARCHAR(45) NOT NULL,
    UtstyrsBeskrivelse TEXT,
    LeieprisDogn DECIMAL(10,2) NOT NULL,
    AntallUtstyr INT,
    AntallPaLager INT,
    PRIMARY KEY (UtstyrsMal_ID)
);

-- ============================================
-- 4) Utstyr (fysiske instanser)
-- ============================================
CREATE TABLE Utstyr (
    UtstyrsMal_ID INT NOT NULL,
    InstansID INT NOT NULL,
    UtstyrSistVedlikeholdtDato DATE,
    NesteVedlikehold DATE,
    PRIMARY KEY (UtstyrsMal_ID, InstansID),
    CONSTRAINT fk_utstyr_utstyrsmal
        FOREIGN KEY (UtstyrsMal_ID)
        REFERENCES UtstyrsMal(UtstyrsMal_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================
-- 5) Utleie
-- Egen enkel primærnøkkel gjør reverse engineer ryddigere.
-- Fortsatt koblet til konkret utstyrsinstans.
-- ============================================
CREATE TABLE Utleie (
    UtleieID INT NOT NULL AUTO_INCREMENT,
    UtleidDato DATE NOT NULL,
    InnlevertDato DATE NULL,
    Betalingsmate VARCHAR(20),
    LeveresKunde TINYINT,
    LeveringsKostnad DECIMAL(6,2),
    UtstyrsMal_ID INT NOT NULL,
    InstansID INT NOT NULL,
    KundebehandlerID INT NOT NULL,
    KundeNr INT NOT NULL,
    PRIMARY KEY (UtleieID),
    CONSTRAINT fk_utleie_utstyr
        FOREIGN KEY (UtstyrsMal_ID, InstansID)
        REFERENCES Utstyr(UtstyrsMal_ID, InstansID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_utleie_kundebehandler
        FOREIGN KEY (KundebehandlerID)
        REFERENCES Kundebehandler(KundebehandlerID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_utleie_kunde
        FOREIGN KEY (KundeNr)
        REFERENCES Kunde(KundeNr)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================
-- DATA
-- ============================================
INSERT INTO Kunde (
    KundeNr, Kundenavn, KundeType, KundeEpost,
    LeveringAdrGate, LeveringAdrGateNr, LeveringAdrPostNr, LeveringAdrPoststed,
    FakturaAdrGate, FakturaAdrGateNr, FakturaAdrPostNr, FakturaAdrPoststed
) VALUES
(8988,  'Murer Pedersen ANS', 'Bedrift', 'mu_pe@ånnlain.no', 'Murergata',   '2',   '9000', 'Tromsø', 'Murergata',  '1',   '9000', 'Tromsø'),
(10002, 'Grøft og Kant AS',   'Bedrift', 'gm@uuiitt.nu',    'Lillegata',   '233', '8000', 'Bodø',   'Øvregata',   '332', '8000', 'Bodø'),
(11122, 'Lokalbyggern AS',    'Bedrift', 'lok_bygg@no.no',  'Veien',       '124', '8000', 'Bodø',   'Nedreveien', '223', '8000', 'Bodø'),
(20011, 'Anders Andersen',    'Privat',  'aa@post.no',      'Fjelltoppen', '3',   '8500', 'Narvik', 'Fjelltoppen','4',   '8500', 'Narvik');

INSERT INTO Kundebehandler (KundebehandlerID, KundebehandlerNavn, KundebehandlerTlf) VALUES
(1, 'Hilde Pettersen', '10090999'),
(2, 'Berit Hansen',    '10191999');

INSERT INTO UtstyrsMal (
    UtstyrsMal_ID, UtstyrsMerke, UtstyrsModell, UtstyrsType, Kategori,
    UtstyrsBeskrivelse, LeieprisDogn, AntallUtstyr, AntallPaLager
) VALUES
(233,  'Stanley',      'Vento 6L',   'Kompressor',    'Lette maskiner',
 'Liten og hendig, med en motor på 1,5HK. Regulerbart trykk opp till 8bar, 180L luft i minuttet.', 79.00, 10, 4),
(234,  'ESSVE',        'Coil CN-15-65', 'Spikerpistol','Lette maskiner',
 'ESSVE Coilpistol beregnet for spikring av bjelkelag, reisverk, kledning, utforinger, panel, sponplater m.m.', 100.00, 50, 45),
(1001, 'Hitachi',      'ZX10U-6',    'Minigraver',    'Tunge maskiner',
 'Minigraveren ZX10U-6 fra Hitachi er vår minste minigraver og er laget for bruk på trange og små plasser', 1200.00, 1, 0),
(7653, 'Haki Stilas',  '150',        'Stilas',        'Annleggsutstyr',
 'Stilas på ca 150 kvadratmeter.', 350.00, 2, 1),
(7654, 'Atika',        '130l 600w',  'Sementblander', 'Annleggsutstyr',
 'Atika betongblander med kapasitet på 130 l og 600 W. Bruker 230 V. IP44', 230.00, 8, 4);

INSERT INTO Utstyr (UtstyrsMal_ID, InstansID, UtstyrSistVedlikeholdtDato, NesteVedlikehold) VALUES
(233,  1, '2018-04-03', '2021-04-03'),
(233,  2, '2017-01-02', '2022-01-02'),
(234,  1, '2021-02-10', '2022-02-10'),
(1001, 1, '2019-09-01', '2022-09-01'),
(7653, 1, '2016-12-11', '2021-12-11'),
(7654, 1, '2019-03-20', '2024-03-20');

INSERT INTO Utleie (
    UtleidDato, InnlevertDato, Betalingsmate, LeveresKunde, LeveringsKostnad,
    UtstyrsMal_ID, InstansID, KundebehandlerID, KundeNr
) VALUES
('2019-02-01', '2019-02-03', 'Kort',    0,   0.00, 234,  1, 2, 11122),
('2019-03-05', '2019-03-06', 'Kontant', 0,   0.00, 233,  2, 2, 20011),
('2020-02-04', '2020-02-10', 'Vipps',   1, 200.00, 7654, 1, 2, 8988),
('2021-02-01', NULL,         'Kort',    1, 150.00, 233,  1, 1, 20011),
('2021-02-05', '2021-02-08', 'Kontant', 1, 500.00, 1001, 1, 1, 10002),
('2021-02-05', NULL,         'Kort',    0,   0.00, 7653, 1, 2, 11122);

-- ============================================
-- SPØRRINGER A-E
-- ============================================

-- A
SELECT
    KundeNr,
    Kundenavn,
    KundeEpost,
    FakturaAdrGate,
    FakturaAdrGateNr,
    FakturaAdrPostNr
FROM Kunde
WHERE KundeType = 'Bedrift'
ORDER BY KundeNr;

-- B
SELECT
    u.UtleidDato,
    u.InnlevertDato,
    k.KundeNr,
    um.UtstyrsMal_ID AS UtstyrId,
    um.UtstyrsMerke,
    um.UtstyrsModell,
    um.UtstyrsType
FROM Utleie u
JOIN Kunde k
    ON u.KundeNr = k.KundeNr
JOIN Kundebehandler kb
    ON u.KundebehandlerID = kb.KundebehandlerID
JOIN Utstyr ut
    ON u.UtstyrsMal_ID = ut.UtstyrsMal_ID
   AND u.InstansID = ut.InstansID
JOIN UtstyrsMal um
    ON ut.UtstyrsMal_ID = um.UtstyrsMal_ID
WHERE kb.KundebehandlerNavn = 'Berit Hansen'
  AND u.InnlevertDato IS NULL;

-- C
SELECT COUNT(*) AS AntallKompletteUtleier
FROM Utleie
WHERE UtleidDato >= '2019-01-01'
  AND InnlevertDato <= '2020-02-10'
  AND InnlevertDato IS NOT NULL;

-- D
SELECT
    um.UtstyrsMal_ID,
    SUM(DATEDIFF(u.InnlevertDato, u.UtleidDato) * um.LeieprisDogn + u.LeveringsKostnad) AS SumPerUtstyr,
    um.UtstyrsMerke,
    um.UtstyrsModell,
    um.UtstyrsType
FROM Utleie u
JOIN UtstyrsMal um
    ON u.UtstyrsMal_ID = um.UtstyrsMal_ID
WHERE u.InnlevertDato IS NOT NULL
GROUP BY
    um.UtstyrsMal_ID,
    um.UtstyrsMerke,
    um.UtstyrsModell,
    um.UtstyrsType
HAVING SUM(DATEDIFF(u.InnlevertDato, u.UtleidDato) * um.LeieprisDogn + u.LeveringsKostnad) > 0
ORDER BY SumPerUtstyr DESC;

-- E
SELECT
    COUNT(*) AS AntUtleid,
    um.UtstyrsMerke,
    um.UtstyrsModell,
    um.UtstyrsType,
    um.Kategori
FROM Utleie u
JOIN UtstyrsMal um
    ON u.UtstyrsMal_ID = um.UtstyrsMal_ID
GROUP BY
    um.UtstyrsMal_ID,
    um.UtstyrsMerke,
    um.UtstyrsModell,
    um.UtstyrsType,
    um.Kategori
ORDER BY AntUtleid DESC
LIMIT 1;
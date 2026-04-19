USE oblig3_5tabeller;

CREATE TABLE Login (
    LoginID INT NOT NULL AUTO_INCREMENT,
    Brukernavn VARCHAR(50) NOT NULL UNIQUE,
    PassordHash VARCHAR(255) NOT NULL,
    KundebehandlerID INT NOT NULL UNIQUE,
    PRIMARY KEY (LoginID),
    CONSTRAINT fk_login_kundebehandler
        FOREIGN KEY (KundebehandlerID)
        REFERENCES Kundebehandler(KundebehandlerID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

INSERT INTO Login (Brukernavn, PassordHash, KundebehandlerID)
VALUES
('hilde', 'GENERERES_MED_WERKZEUG', 1),
('berit', 'GENERERES_MED_WERKZEUG', 2);
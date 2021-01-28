DROP SCHEMA IF EXISTS ACME;
CREATE DATABASE IF NOT EXISTS ACME
CHARACTER SET utf8;
SET FOREIGN_KEY_CHECKS = 0;
SET GLOBAL event_scheduler = on;
USE ACME;

DROP TABLE IF EXISTS CatalogoPiante;
CREATE TABLE IF NOT EXISTS CatalogoPiante 

(
	ID INT NOT NULL AUTO_INCREMENT,
	Nome VARCHAR (50) NOT NULL,
	Genere VARCHAR (50) NOT NULL,
	Cultivar VARCHAR (50) NOT NULL,
	DimMax SMALLINT NOT NULL,
	Sempreverde BOOL NOT NULL,
	IndRadicale INT(1) NOT NULL,
	IndAereo INT (1) NOT NULL,
	Dioica BOOL NOT NULL,
    IndManutenzione INT DEFAULT 0,
	UNIQUE(Nome,Genere,Cultivar),
    PRIMARY KEY (ID)
);
DROP TABLE IF EXISTS AccountCliente;
CREATE TABLE IF NOT EXISTS AccountCliente
(
	CodiceUtente INT NOT NULL AUTO_INCREMENT,
    MediaValutRisp FLOAT(2,2) DEFAULT 0,
    NumValRicevute SMALLINT DEFAULT 0,
    Nickname VARCHAR(20) NOT NULL,
    PasswordLogin VARCHAR(20) NOT NULL,
    DomSegreta VARCHAR (150) NOT NULL,
    RispSegreta VARCHAR (100) NOT NULL,
    UNIQUE(Nickname),
    PRIMARY KEY (CodiceUtente)
);
DROP TABLE IF EXISTS AnagraficaCliente;
CREATE TABLE IF NOT EXISTS AnagraficaCliente
(
	AccountCliente INT NOT NULL,
    Email VARCHAR(40) NOT NULL,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    Indirizzo VARCHAR(50) NOT NULL,
    CittaResidenza VARCHAR(70) NOT NULL,
    PRIMARY KEY (AccountCliente),
    FOREIGN KEY (AccountCliente) 
		REFERENCES AccountCliente (CodiceUtente)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

DROP TABLE IF EXISTS CatalogoIntervento;
CREATE TABLE IF NOT EXISTS CatalogoIntervento (
	Codice INT NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Tipologia VARCHAR(20) NOT NULL,
    Descrizione TINYTEXT,
    Qualifica VARCHAR(20),
    PRIMARY KEY (Codice)
);

DROP TABLE IF EXISTS Sede;
CREATE TABLE IF NOT EXISTS Sede
(
	Codice INT NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Indirizzo VARCHAR(200) NOT NULL,
    PRIMARY KEY (Codice)
);

DROP TABLE IF EXISTS Serra;
CREATE TABLE IF NOT EXISTS Serra
(
	Codice INT NOT NULL,
    Sede INT,
    Nome VARCHAR(100) NOT NULL,
    Indirizzo VARCHAR(100) NOT NULL,
    NumPianteMax INT NOT NULL,
    X DECIMAL NOT NULL,
    Y DECIMAL NOT NULL,
    Z DECIMAL NOT NULL,
    PRIMARY KEY (Codice),
    FOREIGN KEY (Sede) 
		REFERENCES Sede (Codice)
		ON UPDATE CASCADE
        ON DELETE SET NULL
	);
    
DROP TABLE IF EXISTS Sezione;
CREATE TABLE IF NOT EXISTS Sezione
(
	Codice INT NOT NULL,
    Serra INT NOT NULL,
    Temperatura FLOAT(4,2),
    Umidita FLOAT(4,2),
    Illuminazione ENUM('Bassa', 'Media', 'Alta'),
    PRIMARY KEY (Codice),
    FOREIGN KEY (Serra) 
		REFERENCES Serra (Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);
DROP TABLE IF EXISTS Ripiano;
CREATE TABLE IF NOT EXISTS Ripiano 
(
	Codice INT NOT NULL,
    Sezione INT NOT NULL,
    Irrigazione ENUM('Bassa','Media','Alta'),
    PRIMARY KEY (Codice),
    FOREIGN KEY (Sezione) 
		REFERENCES Sezione (Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Pianta;
CREATE TABLE IF NOT EXISTS Pianta (
	Codice INT NOT NULL,
    CatalogoPiante INT NOT NULL,
    Serra INT NOT NULL,
    Sesso CHAR(1),
    DimAttuale ENUM('Piccola','Media','Grande'),
    PRIMARY KEY (Codice),
    FOREIGN KEY (CatalogoPiante) 
		REFERENCES CatalogoPiante (ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	FOREIGN KEY (Serra)
		REFERENCES Serra (Codice)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Contenitore;
CREATE TABLE IF NOT EXISTS Contenitore (
	Codice INT NOT NULL,
    Pianta INT,
    Ripiano INT,
    Idratazione FLOAT(4,2) NOT NULL,
    Dimensione ENUM('Piccola','Media','Grande') NOT NULL,
    ConsistenzaSubstrato ENUM('Friabile','Intermedio','Compatto'),
    PermeabilitaTerreno ENUM('Bassa','Media','Alta'),
    PRIMARY KEY (Codice),
    FOREIGN KEY (Pianta) 
		REFERENCES Pianta (Codice)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
	FOREIGN KEY (Ripiano)
		REFERENCES Ripiano (Codice)
		ON DELETE SET NULL
        ON UPDATE CASCADE
	);
    
DROP TABLE IF EXISTS Dipendente;
CREATE TABLE IF NOT EXISTS Dipendente 
(
	CodiceFiscale CHAR(16) NOT NULL,
    Sede INT,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    Indirizzo VARCHAR(50) NOT NULL,
    Stipendio DECIMAL(8,2) NOT NULL,
    Qualifica VARCHAR(20),
    PRIMARY KEY (CodiceFiscale),
    FOREIGN KEY (Sede) 
		REFERENCES Sede (Codice)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

DROP TABLE IF EXISTS Elemento;
CREATE TABLE IF NOT EXISTS Elemento 
(
	Nome VARCHAR(20) NOT NULL,
    Categoria ENUM('Microelemento','Macroelemento','Rinverdente','Concime') NOT NULL,
    PRIMARY KEY (Nome)
);

DROP TABLE IF EXISTS Esigenze;
CREATE TABLE IF NOT EXISTS Esigenze 
(
	CatalogoPiante INT NOT NULL,
    Consistenza ENUM ('Compatto','Intermedio','Friabile'),
    PH DECIMAL(3,1),
    Permeabilita ENUM('Bassa','Media','Alta'),
	IrrigazioniRiposoSettimanali INT (2),
    IrrigazioniVegetativoSettimanali INT (2) NOT NULL, 
    TempMax INT(2) NOT NULL,
    TempMin INT(2) NOT NULL,
    OreLuceVeg INT (2) NOT NULL,
    OreLuceRip INT (2) NOT NULL,
    LuceDiretta BOOL NOT NULL, 
    QuantitaLuce VARCHAR(20) NOT NULL,
    PRIMARY KEY (CatalogoPiante),
    FOREIGN KEY (CatalogoPiante) 
		REFERENCES CatalogoPiante (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Farmaco;
CREATE TABLE IF NOT EXISTS Farmaco
(
	Codice INT NOT NULL,
    NomeCommerciale VARCHAR(50) NOT NULL,
    Tipologia ENUM('Ampio Spettro','Selettivo'),
    PRIMARY KEY (Codice)
);

DROP TABLE IF EXISTS PrincipioAttivo;
CREATE TABLE IF NOT EXISTS PrincipioAttivo
(
	Nome VARCHAR(50) NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS Formulazione;
CREATE TABLE IF NOT EXISTS Formulazione
(
	Farmaco INT NOT NULL,
    PrincipioAttivo VARCHAR(50) NOT NULL,
    Concentrazione INT NOT NULL,
    PRIMARY KEY (Farmaco, PrincipioAttivo),
    FOREIGN KEY (Farmaco)
		REFERENCES Farmaco (Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (PrincipioAttivo)
		REFERENCES PrincipioAttivo (Nome)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS ReportDiagnostica;
CREATE TABLE IF NOT EXISTS ReportDiagnostica
(
	ID INT NOT NULL AUTO_INCREMENT,
    TimestampReport TIMESTAMP,
    PRIMARY KEY (ID)
);

DROP TABLE IF EXISTS Diagnosi;
CREATE TABLE IF NOT EXISTS Diagnosi 
(
	ID INT NOT NULL AUTO_INCREMENT,
    Pianta INT NOT NULL,
    TimestampDiagnosi TIMESTAMP,
    PRIMARY KEY (ID),
    FOREIGN KEY (Pianta)
		REFERENCES Pianta (Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

DROP TABLE IF EXISTS Inclusione;
CREATE TABLE IF NOT EXISTS Inclusione
(
	Diagnosi INT NOT NULL,
    ReportDiagnostica INT NOT NULL,
    PRIMARY KEY (Diagnosi, ReportDiagnostica),
    FOREIGN KEY (Diagnosi) 
		REFERENCES Diagnosi (ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
	FOREIGN KEY (ReportDiagnostica)
		REFERENCES ReportDiagnostica (ID)
		ON DELETE NO ACTION
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Patologia;
CREATE TABLE IF NOT EXISTS Patologia
(
	Nome VARCHAR(50) NOT NULL,
    Descrizione TINYTEXT,
    AgentePatogeno VARCHAR(50) NOT NULL,
    PRIMARY KEY (Nome)
);

DROP TABLE IF EXISTS PeriodoFruttificazione;
CREATE TABLE IF NOT EXISTS PeriodoFruttificazione
(
	ID INT NOT NULL AUTO_INCREMENT,
    CatalogoPiante INT NOT NULL,
    MeseInizio INT(2) NOT NULL, 
    MeseFine INT(2) NOT NULL, 
    PRIMARY KEY (ID),
    FOREIGN KEY (CatalogoPiante) 
		REFERENCES CatalogoPiante (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Sintomo;
CREATE TABLE IF NOT EXISTS Sintomo
(
	Codice INT NOT NULL,
    Descrizione TINYTEXT,
    PRIMARY KEY (Codice)
);

DROP TABLE IF EXISTS Indicazione;
CREATE TABLE IF NOT EXISTS Indicazione
(
	ID INT NOT NULL AUTO_INCREMENT,
    Patologia VARCHAR(50) NOT NULL,
    Farmaco INT NOT NULL,
    Somministrazione ENUM('Spruzzatura','Terreno','Nebulizzazione') NOT NULL,
    Dosaggio FLOAT(7,2) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Patologia)
		REFERENCES Patologia (Nome)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Farmaco) 
		REFERENCES Farmaco (Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Terreno;
CREATE TABLE IF NOT EXISTS Terreno
(
	NOME VARCHAR(20) NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS Risorse;
CREATE TABLE IF NOT EXISTS Risorse
(
	Codice INT NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    PRIMARY KEY (Codice)
);

DROP TABLE IF EXISTS Causa;
CREATE TABLE IF NOT EXISTS Causa
(
	Patologia VARCHAR(50) NOT NULL,
    Sintomo INT NOT NULL,
    PRIMARY KEY (Patologia, Sintomo)
);

DROP TABLE IF EXISTS ComposizioneChimica;
CREATE TABLE IF NOT EXISTS ComposizioneChimica
(
	Contenitore INT NOT NULL,
    Elemento VARCHAR(50) NOT NULL,
    Dose FLOAT (6,2) NOT NULL,
    PRIMARY KEY (Contenitore, Elemento),
    FOREIGN KEY (Contenitore) 
		REFERENCES Contenitore (Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Elemento)
		REFERENCES Elemento (Nome)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS ComposizioneSubstrato;
CREATE TABLE IF NOT EXISTS ComposizioneSubstrato
(
	Contenitore INT NOT NULL,
    Terreno VARCHAR(20) NOT NULL,
    Percentuale FLOAT (4,2) NOT NULL,
    PRIMARY KEY (Contenitore, Terreno),
    FOREIGN KEY (Contenitore) 
		REFERENCES Contenitore (Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Terreno)
		REFERENCES Terreno (Nome)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS ContenutoIn;
CREATE TABLE IF NOT EXISTS ContenutoIn
(
	ID INT NOT NULL AUTO_INCREMENT,
    Diagnosi INT NOT NULL,
    Elemento VARCHAR(30) NOT NULL,
    Percentuale FLOAT (4,2) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Diagnosi) 
		REFERENCES Diagnosi (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Elemento)
		REFERENCES Elemento (Nome)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS ImmagineCampione;
CREATE TABLE IF NOT EXISTS ImmagineCampione
(
	ID INT NOT NULL AUTO_INCREMENT,
    Sintomo INT NOT NULL,
    URL VARCHAR(100) NOT NULL,
    PRIMARY KEY(ID),
    FOREIGN KEY (Sintomo) 
		REFERENCES Sintomo (Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Ipotesi;
CREATE TABLE IF NOT EXISTS Ipotesi
(
	ID INT NOT NULL AUTO_INCREMENT,
    Diagnosi INT NOT NULL,
    Patologia VARCHAR(50) NOT NULL,
    Certezza FLOAT (4,2),
    PRIMARY KEY (ID),
    FOREIGN KEY (Diagnosi)
		REFERENCES Diagnosi (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Patologia)
		REFERENCES Patologia (Nome)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS PeriodoManutenzione;
CREATE TABLE IF NOT EXISTS PeriodoManutenzione
(
	ID INT NOT NULL AUTO_INCREMENT,
    CatalogoIntervento INT NOT NULL,
    CatalogoPiante INT NOT NULL,
    MeseInizio INT NOT NULL,   
    MeseFine INT NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (CatalogoIntervento)
		REFERENCES CatalogoIntervento (Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (CatalogoPiante)
		REFERENCES CatalogoPiante (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Prezzo;
CREATE TABLE IF NOT EXISTS Prezzo 
(
	CatalogoPiante INT NOT NULL,
    Dimensione ENUM('Piccola','Media','Grande'),
    Prezzo	FLOAT(8,2),
    PRIMARY KEY (CatalogoPiante, Dimensione),
    FOREIGN KEY (CatalogoPiante)
		REFERENCES CatalogoPiante (ID)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Riscontro;
CREATE TABLE IF NOT EXISTS Riscontro
(
	Sintomo INT NOT NULL,
    Diagnosi INT NOT NULL,
    PRIMARY KEY (Sintomo, Diagnosi),
    FOREIGN KEY (Sintomo)
		REFERENCES Sintomo (Codice)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	FOREIGN KEY (Diagnosi) 
		REFERENCES Diagnosi (ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Somministrazione;
CREATE TABLE IF NOT EXISTS Somministrazione
-- mese NULL indica che l'elemento e' sempre necessario
(
	ID INT NOT NULL,
    Elemento VARCHAR(20) NOT NULL,
    CatalogoPiante INT NOT NULL,
    MeseInizio INT DEFAULT NULL,
    MeseFine INT DEFAULT NULL,
    Dose FLOAT(6,2) NOT NULL, 
    PRIMARY KEY (ID),
    FOREIGN KEY (Elemento)
		REFERENCES Elemento (Nome),
	FOREIGN KEY (CatalogoPiante)
		REFERENCES CatalogoPiante (ID),
	UNIQUE(CatalogoPiante, Elemento, MeseInizio, MeseFine)
);

DROP TABLE IF EXISTS Stoccaggio;
CREATE TABLE IF NOT EXISTS Stoccaggio
(
    Risorse INT NOT NULL,
    Sede INT NOT NULL,
    Quantita FLOAT(8,2) NOT NULL,
    PRIMARY KEY (Risorse, Sede),
    FOREIGN KEY (Risorse)
		REFERENCES Risorse (Codice),
	FOREIGN KEY (Sede)
		REFERENCES Sede (Codice)
);

DROP TABLE IF EXISTS Trattamento;
CREATE TABLE IF NOT EXISTS Trattamento
(
	ID INT NOT NULL AUTO_INCREMENT,
    Pianta INT NOT NULL,
    TimestampTrattamento TIMESTAMP NOT NULL,
    Esito VARCHAR(20) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Pianta)
		REFERENCES Pianta (Codice)
);

DROP TABLE IF EXISTS Utilizzo;
CREATE TABLE IF NOT EXISTS Utilizzo 
(
	Farmaco INT NOT NULL,
    Trattamento INT NOT NULL,
    PRIMARY KEY (Farmaco, Trattamento),
    FOREIGN KEY (Farmaco)
		REFERENCES Farmaco (Codice),
	FOREIGN KEY (Trattamento)
		REFERENCES Trattamento (ID)
);

DROP TABLE IF EXISTS Post;
CREATE TABLE IF NOT EXISTS Post
(
	ID INT NOT NULL AUTO_INCREMENT,
    AccountCliente INT NOT NULL,
    Testo TINYTEXT,
    TimestampPost TIMESTAMP,
    PRIMARY KEY (ID),
    UNIQUE(AccountCliente,TimestampPost),
    FOREIGN KEY (AccountCliente)
		REFERENCES AccountCliente (CodiceUtente)
        ON UPDATE CASCADE
        ON DELETE NO ACTION			
);

DROP TABLE IF EXISTS PostArchivio;
CREATE TABLE IF NOT EXISTS PostArchivio
(
	ID INT NOT NULL AUTO_INCREMENT,
    AccountCliente INT NOT NULL,
	Testo TINYTEXT,
    TimestampPost TIMESTAMP,
    PRIMARY KEY (ID),
    UNIQUE(TimestampPost,AccountCliente),
    FOREIGN KEY (AccountCliente)
		REFERENCES AccountCliente (CodiceUtente)
        ON UPDATE CASCADE
		ON DELETE NO ACTION
);

DROP TABLE IF EXISTS SchedaPianta;
CREATE TABLE IF NOT EXISTS SchedaPianta 
(
	ID INT NOT NULL AUTO_INCREMENT,
    AccountCliente INT NOT NULL,
    CatalogoPiante INT NOT NULL,
    ManAuto BOOL NOT NULL,
    DataAcquisto DATE NOT NULL,
    DimAcquisto ENUM('Piccola','Media','Grande') NOT NULL,
    RiceveNotifiche BOOL NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (AccountCliente)
		REFERENCES AccountCliente (CodiceUtente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (CatalogoPiante)
		REFERENCES CatalogoPiante (ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Prospetto;
CREATE TABLE IF NOT EXISTS Prospetto
(
	ID INT NOT NULL AUTO_INCREMENT,
    AccountCliente INT NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Descrizione TINYTEXT,
    PRIMARY KEY (ID),
    FOREIGN KEY (AccountCliente) 
		REFERENCES AccountCliente (CodiceUtente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Spazio;
CREATE TABLE IF NOT EXISTS Spazio
(
	ID INT NOT NULL AUTO_INCREMENT,
    Prospetto INT NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Prospetto)
		REFERENCES Prospetto (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Settore;
CREATE TABLE IF NOT EXISTS Settore
(
	ID INT NOT NULL AUTO_INCREMENT,
    Spazio INT NOT NULL,
    Orientamento VARCHAR(20) NOT NULL,
    OreSole INT(2) NOT NULL,
    LuceDiretta BOOL NOT NULL,
    PienaTerra BOOL NOT NULL,
	PRIMARY KEY (ID),
    FOREIGN KEY (Spazio) 
		REFERENCES Spazio (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Vaso;
CREATE TABLE IF NOT EXISTS Vaso
(
	ID INT NOT NULL AUTO_INCREMENT,
    Settore INT NOT NULL,
    X FLOAT (8,2) NOT NULL,
    Y FLOAT (8,2) NOT NULL,
    Raggio FLOAT (8,2) NOT NULL,
    Materiale VARCHAR(20) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Settore) 
		REFERENCES Settore (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS VerticeSettore;
CREATE TABLE IF NOT EXISTS VerticeSettore 
(
	ID INT NOT NULL AUTO_INCREMENT,
    Settore INT NOT NULL,
    X FLOAT (8,2) NOT NULL,
    Y FLOAT (8,2) NOT NULL,
    PRIMARY KEY (ID, Settore),
    FOREIGN KEY (Settore) 
		REFERENCES Settore (ID)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS VerticeSpazio;
CREATE TABLE IF NOT EXISTS VerticeSpazio
(
	ID INT NOT NULL AUTO_INCREMENT,
    Spazio INT NOT NULL,
    X FLOAT (8,2) NOT NULL,
    Y FLOAT (8,2) NOT NULL,
    PRIMARY KEY (ID, Spazio),
    FOREIGN KEY (Spazio) 
		REFERENCES Spazio (ID)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Ordine;
CREATE TABLE IF NOT EXISTS Ordine 
(
	ID INT NOT NULL AUTO_INCREMENT,
    AccountCliente INT NOT NULL,
    ImportoTotale DECIMAL,
    Stato ENUM ('Pendente', 'In Processazione', 'Evaso') NOT NULL,
    TimestampEvasione TIMESTAMP NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (AccountCliente)
		REFERENCES AccountCliente (CodiceUtente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
-- ATTENZIONE!!!! CONTROLLARE SE LA SCHEDA PIANTA È DELLO STESSO ACCOUNT
DROP TABLE IF EXISTS Accoglie;
CREATE TABLE IF NOT EXISTS Accoglie 
(
	ID INT NOT NULL AUTO_INCREMENT,
	SchedaPianta INT NOT NULL,
    Settore INT NOT NULL,
    X FLOAT(6,2) NOT NULL,
    Y FLOAT(6,2) NOT NULL,
    Raggio FLOAT(6,2) NOT NULL,
    UNIQUE(ID),
    PRIMARY KEY (ID),
    FOREIGN KEY (SchedaPianta)
		REFERENCES SchedaPianta (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Settore)
		REFERENCES Settore (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Ospita;
CREATE TABLE IF NOT EXISTS Ospita
(
	SchedaPianta INT NOT NULL,
    Vaso INT NOT NULL,
    PRIMARY KEY (SchedaPianta, Vaso),
    FOREIGN KEY (SchedaPianta)
		REFERENCES SchedaPianta (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Vaso)
		REFERENCES Vaso (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS AccoglieCatalogo;
CREATE TABLE IF NOT EXISTS AccoglieCatalogo
(
	ID INT NOT NULL,
	CatalogoPiante INT NOT NULL,
    Settore INT NOT NULL,
    X FLOAT(6,2) NOT NULL,
    Y FLOAT(6,2) NOT NULL,
    Raggio FLOAT(6,2) NOT NULL,
    UNIQUE(X,Y,Settore),
    PRIMARY KEY (ID),
    FOREIGN KEY (CatalogoPiante)
		REFERENCES CatalogoPiante (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Settore)
		REFERENCES Settore (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS OspitaCatalogo;
CREATE TABLE IF NOT EXISTS OspitaCatalogo
(
	CatalogoPiante INT NOT NULL,
    Vaso INT NOT NULL,
    PRIMARY KEY (CatalogoPiante, Vaso),
    FOREIGN KEY (CatalogoPiante)
		REFERENCES CatalogoPiante (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Vaso)
		REFERENCES Vaso (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS ArticoloPendente;
CREATE TABLE IF NOT EXISTS ArticoloPendente
(
	ID INT NOT NULL AUTO_INCREMENT,
	CatalogoPiante INT NOT NULL,
    Ordine INT NOT NULL,
    Dimensione ENUM('Piccola','Media','Grande'),
    Sesso ENUM('M','F'),
    PRIMARY KEY (ID),
	FOREIGN KEY (CatalogoPiante)
		REFERENCES CatalogoPiante (ID)
		ON UPDATE CASCADE
        ON DELETE RESTRICT,
	FOREIGN KEY (Ordine)
		REFERENCES Ordine (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Articolo;
CREATE TABLE IF NOT EXISTS Articolo 
(
	Pianta INT NOT NULL,
    Ordine INT NOT NULL,
    PRIMARY KEY (Pianta, Ordine),
    FOREIGN KEY (Pianta) 
		REFERENCES Pianta (Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Ordine)
		REFERENCES Ordine (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Risposta;
CREATE TABLE IF NOT EXISTS Risposta
(
	ID INT NOT NULL AUTO_INCREMENT,
    Post INT NOT NULL,
    AccountCliente INT NOT NULL,
    Testo TINYTEXT NOT NULL,
    TimestampRisposta TIMESTAMP NOT NULL,
    PRIMARY KEY (ID, Post),
    FOREIGN KEY (Post)
		REFERENCES Post (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (AccountCliente)
		REFERENCES AccountCliente (CodiceUtente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS RispostaArchivio;
CREATE TABLE IF NOT EXISTS RispostaArchivio
(
	ID INT NOT NULL AUTO_INCREMENT,
    PostArchivio INT NOT NULL,
    AccountCliente INT NOT NULL,
    Testo TINYTEXT NOT NULL,
    TimestampRisposta TIMESTAMP NOT NULL,
    PRIMARY KEY (ID, PostArchivio),
    FOREIGN KEY (PostArchivio)
		REFERENCES PostArchivio (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (AccountCliente)
		REFERENCES AccountCliente (CodiceUtente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS LinkPost;
CREATE TABLE IF NOT EXISTS LinkPost
(
	ID INT NOT NULL AUTO_INCREMENT,
    Post INT NOT NULL,
    URL VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID),
	FOREIGN KEY (Post)
		REFERENCES Post (ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS LinkRisposta;
CREATE TABLE IF NOT EXISTS LinkRisposta
(
	ID INT NOT NULL AUTO_INCREMENT,
    Post INT NOT NULL,
    Risposta INT NOT NULL,
    URL VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Risposta)
		REFERENCES Risposta (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (Post)
		REFERENCES Risposta (Post)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS LinkPostArchivio;
CREATE TABLE IF NOT EXISTS LinkPostArchivio
(
	ID INT NOT NULL AUTO_INCREMENT,
    PostArchivio INT NOT NULL,
    URL VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID),
	FOREIGN KEY (PostArchivio)
		REFERENCES PostArchivio (ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS LinkRispArchivio;
CREATE TABLE IF NOT EXISTS LinkRispArchivio
(
	ID INT NOT NULL AUTO_INCREMENT,
    PostArchivio INT NOT NULL,
    RispostaArchivio INT NOT NULL,
    URL VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (RispostaArchivio)
		REFERENCES RispostaArchivio (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (PostArchivio)
		REFERENCES RispostaArchivio (PostArchivio)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Preferenze;
CREATE TABLE IF NOT EXISTS Preferenze
(
	AccountCliente INT NOT NULL,
    CatalogoPiante INT NOT NULL,
    PRIMARY KEY (AccountCliente, CatalogoPiante),
    FOREIGN KEY (AccountCliente)
		REFERENCES AccountCliente(CodiceUtente)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (CatalogoPiante)
		REFERENCES CatalogoPiante(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS SchedaIntervento;
CREATE TABLE IF NOT EXISTS SchedaIntervento
(
	ID INT NOT NULL AUTO_INCREMENT,
    Ordine INT NOT NULL,
    SchedaPianta INT NOT NULL,
    CatalogoIntervento INT NOT NULL,
    Luogo VARCHAR(50) NOT NULL,
    DataEsecuzioneSopralluogo DATE,
    Prezzo FLOAT(6,2),
    Stato ENUM('Eseguito', 'Prenotato') NOT NULL,
    TipoPeriodicita ENUM ('Richiesta','Programmata','Autonoma','Automatica') NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Ordine) 
		REFERENCES Ordine (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (CatalogoIntervento)
		REFERENCES CatalogoIntervento (Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Disponibilita;
CREATE TABLE IF NOT EXISTS Disponibilita
(
	Dipendente CHAR(16) NOT NULL,
    SchedaIntervento INT NOT NULL,
    PRIMARY KEY (Dipendente, SchedaIntervento),
    FOREIGN KEY (Dipendente)
		REFERENCES Dipendente (CodiceFiscale)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (SchedaIntervento)
		REFERENCES SchedaIntervento (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS DataManutenzione;
CREATE TABLE IF NOT EXISTS DataManutenzione
(
	SchedaIntervento INT NOT NULL,
    DataIntervento DATE NOT NULL,
    Stato ENUM('Programmata','Eseguita'),
    PRIMARY KEY (SchedaIntervento, DataIntervento),
	FOREIGN KEY (SchedaIntervento)
		REFERENCES SchedaIntervento (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Richiede;
CREATE TABLE IF NOT EXISTS Richiede
(
	SchedaIntervento INT NOT NULL,
    Risorse INT NOT NULL,
    Quantita FLOAT (8,2) NOT NULL,
    
    PRIMARY KEY (SchedaIntervento, Risorse),
    FOREIGN KEY (SchedaIntervento)
		REFERENCES SchedaIntervento (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Risorse)
		REFERENCES Risorse (Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS Valuta;
CREATE TABLE IF NOT EXISTS Valuta
(
	Post INT NOT NULL,
	Risposta INT NOT NULL,
    AccountCliente INT NOT NULL,
    Voto INT(1) NOT NULL,
    TimestampValutazione TIMESTAMP,
    PRIMARY KEY (Risposta, AccountCliente, Post),
    FOREIGN KEY (Risposta)
		REFERENCES Risposta (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (AccountCliente)
		REFERENCES AccountCliente(CodiceUtente)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Post)
		REFERENCES Risposta (Post)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS ValutaArchivio;
CREATE TABLE IF NOT EXISTS ValutaArchivio (

	PostArchivio INT NOT NULL,
    RispostaArchivio INT NOT NULL,
    AccountCliente INT NOT NULL,
    Voto INT(1) NOT NULL,
    TimestampValutazione TIMESTAMP,
    PRIMARY KEY (RispostaArchivio , AccountCliente, PostArchivio),
    FOREIGN KEY (RispostaArchivio)
        REFERENCES RispostaArchivio (ID)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    FOREIGN KEY (AccountCliente)
        REFERENCES AccountCliente (CodiceUtente)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
	FOREIGN KEY (PostArchivio)
		REFERENCES RispostaArchivio (PostArchivio)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS PianteVendute;
CREATE TABLE PianteVendute LIKE Pianta;

DROP TABLE IF EXISTS DiagnosiPianteVendute;
CREATE TABLE IF NOT EXISTS DiagnosiPianteVendute
(
	ID INT NOT NULL AUTO_INCREMENT,
    Pianta INT NOT NULL,
    TimestampDiagnosi TIMESTAMP,
    ReportDiagnostica INT,
    PRIMARY KEY (ID),
    FOREIGN KEY (ReportDiagnostica)
		REFERENCES ReportDiagnostica (ID)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (Pianta)
		REFERENCES PianteVendute (Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

SET FOREIGN_KEY_CHECKS = 1;

USE ACME;

insert into AccountCliente (CodiceUtente, MediaValutRisp, NumValRicevute, Nickname, PasswordLogin, DomSegreta, RispSegreta)
	values (1, NULL, NULL, 'Marco85', 'mamama', 'La tua città preferita?', 'Pisa'),
		   (2, NULL, NULL, 'Maria99', 'manama', 'La tua città preferita?', 'Pisa'),
           (3, NULL, NULL, 'Gianni12', 'gigigi', 'La tua città preferita?', 'Pisa'),
           (4, NULL, NULL, 'Giovanna56', 'gigaga', 'La tua città preferita?', 'Pisa'),
           (5, NULL, NULL, 'Lorenzo33', 'lololo', 'La tua città preferita?', 'Pisa'),
           (6, NULL, NULL, 'Letizia88', 'lelele', 'La tua città preferita?', 'Pisa'),
           (7, NULL, NULL, 'RickAstley', 'trololololol', 'La tua frase preferita?', 'Never gonna give you up'),
           (8, NULL, NULL, 'MarcoDiGiu', 'SalutAnto', 'La tua città preferita?', 'Paleermo'),
           (9, NULL, NULL, 'Massimiliano', 'Massi', 'La tua frase preferita?', 'La domenica dal barbiere'),
           (10, NULL, NULL, 'Cristo00', 'Integra', 'La tua città preferita?', 'Pisa');

insert into AnagraficaCliente (AccountCliente, Email, Nome, Cognome, Indirizzo, CittaResidenza)
	values (1, 'MarconeMar@gmail.com', 'Marco', 'Boddi', 'Via dei caduti, 18', 'Ponsacco'),
		   (2, 'Mari.linaSaba@gmail.com', 'Maria', 'Saba', 'Piazza Italia, 1', 'Fornacette'),
           (3, 'Giagia@gmail.com', 'Gianni', 'Pomerani', 'Via Cesare Battisti, 12', 'Pisa'),
           (4, 'GioAzzurri@gmail.com', 'Giovanna', 'Azzurri', 'Viale della rimembranza, 23', 'Livorno'),
           (5, 'Loretto@gmail.com', 'Lorenzo', 'Cioni', 'Via Delle Marmotte, 44', 'Pavia'),
           (6, 'Lete88@gmail.com', 'Letizia', 'Bianchi', 'Viale Primo Maggio, 1', 'Roma'),
           (7, 'Ricky@hotmail.com', 'Rick', 'Astley', 'Saint Boulevard, 1', 'California'),
           (8, 'Marcodep@gmail.com', 'Marco', 'DiStefano', 'Via Bruno Buozzi, 22', 'Catania'),
           (9, 'Massibarba@gmail.com', 'Massimiliano', 'Simoncini', 'Via Firenze, 1', 'Ponsacco'),
           (10, 'Crosti@gmail.com', 'Cristofaro', 'DiPuorto', 'Via Cesare Battisti, 14', 'Reggio Emilia');
           
insert into CatalogoIntervento
	values ('1','Potatura estetica', 'Potatura', 'Intervento di potatura che può essere effettuato su ogni tipo di pianta',NULL),
		   ('2','Potatura rinvigorente', 'Potatura', 'Rimozione di arbusti o rami danneggiati o malati per preservare la buona salute della pianta',NULL),
           ('3','Capitozzatura','Potatura','tecnica di potatura che consiste nel taglio dei rami sopra il punto di intersezione con il tronco o altro ramo principale',NULL),('4','Rinverdimento Foglie','Spruzzatura','Spruzzatura di rinverdente sulle foglie delle piante.',NULL),('5','Concimazione generica','Concimazione','Somministrazione di uno o più prodotti',NULL),
           ('6','Trattamento insetticida estivo','Spruzzatura','Somministrazione di prodotto insetticida stagionale','Sostanze pericolose'),
           ('7','Abbattimento','Abbattimento','Rimozione di un albero dal giardino','Mezzi Pesanti'),
           ('8','Travaso','Travaso','Interramento di una o più piante ospitate in vasi',NULL),
           ('9','Sanificazione','Disinfestazione','Trattamento a lungo termine contro insetti','Sostanze pericolose'),
           ('10','Rimozione piante infestanti','Disinfestazione','Rimozione di piante infestanti non desiderate',NULL);
           
           
insert into CatalogoPiante (ID, Genere, Cultivar, Nome, DimMax, Sempreverde, IndAereo, IndRadicale, Dioica)
	values (1, 'Pseudostenosiphonium', 'Adams Pearmain', '    Origano', 5, false, 5, 2, true),
		   (2, 'Psilanthele', 'Admiral', '    Alloro', 16, true, 9, 7, true),
           (3, 'Pteracanthus', 'Aia Llu', '    Prezzemolo', 29, false, 8, 4, true),
           (4, 'Pteroptychia', 'Airle Red Flesh', '    Erica', 2, true, 4, 5, false),
           (5, 'Ptyssiglottis', 'Akane', '    Aglio', 9, false, 1, 1, false),
           (6, 'Pulchranthus', 'Akero', '    Carota', 11, false, 5, 4, false),
           (7, 'Pupilla', 'Aikmene AGM', '    Zenzero', 24, false, 2, 3, true),
           (8, 'Pyrrothrix', 'Allington Pippin', '    Giuggiolo', 3, false, 1, 4, true),
           (9, 'Razisea', 'Ambrosia', '    Luppolo', 25, false, 2, 8, true),
           (10, 'Rhaphidospora', 'Anna', '    Cardo', 3, false, 1, 3, false),
		   (11, 'Rhinacanthus', 'Annurca', '    Peperoncino', 30, false, 9, 2, true),
		   (12, 'Ruellia', 'Antonovka', '    Origano', 10, false, 8, 6, false),
		   (13, 'Rungia', 'Apollo', '    Miglio', 11, false, 7, 8, false),
		   (14, 'Ruspolia', 'Ariane', '    Rosmarino', 21, false, 3, 4, false),
		   (15, 'Ruttya', 'Arkansas Black', '    Anemone', 6, false, 7, 4, true);


insert into Sede (Codice, Nome, Indirizzo) 
	values  (1, 'Alpe Cottino', 'Roma'),
			(2, 'Astano', 'Milano'),
		    (3, 'Balbio', 'Napoli'),
		    (4, 'Barbana', 'Torino'),
		    (5, 'Beredino', 'Palermo'),
		    (6, 'Bisio', 'Genova'),
		    (7, 'Brei', 'Bologna'),
		    (8, 'Bruciata', 'Firenze'),
		    (9, 'Campocologno', 'Bari'),
		    (10, 'Castelletto Zeglo', 'Catania');
            
            
insert into Dipendente (CodiceFiscale, Sede, Nome, Cognome, Indirizzo, Stipendio, Qualifica) 
	values  ('04-2710935', 1, 'Philip', 'Shaw', '10008 Old Shore Drive', 2052.93, 'Mezzi Pesanti'),
			('67-9069532', 2, 'Anthony', 'Barnes', '5 Stephen Terrace', 2901.2, null),
			('94-3035559', 3, 'Amanda', 'Martin', '65 Luster Court', 2476.72, 'Conducente Camion'),
			('16-1637495', 4, 'Fred', 'Howard', '4981 Hauk Park', 1268.01, null),
			('75-8376869', 5, 'Anthony', 'Mason', '1 Crest Line Street', 1583.39, null),
			('33-0389701', 6, 'Lawrence', 'Gonzales', '1839 Northland Way', 2610.2, 'Conducente Camion'),
			('66-8247868', 7, 'Tina', 'Murphy', '4420 Lighthouse Bay Court', 2826.63, 'Conducente Camion'),
			('25-7798646', 8, 'Charles', 'Simmons', '17 Manitowish Center', 2608.88, 'Sostanze Pericolose'),	
			('40-2687776', 9, 'Ruth', 'Mitchell', '5 Corben Terrace', 2509.16, 'Conducente Camion'),
			('79-3651673', 10, 'Antonio', 'Meyer', '7844 Barby Terrace', 2850.58, 'Conducente Camion'),
			('06-8260272', 1, 'Brian', 'Garrett', '77 Pine View Hill', 2341.3, null),
			('20-1326101', 2, 'Christopher', 'Murray', '4 Linden Way', 1470.33, 'Sostanze Pericolose'),
			('42-0705301', 3, 'Richard', 'Wallace', '0 2nd Hill', 2054.78, 'Sostanze Pericolose'),
			('52-5489284', 4, 'Louise', 'Weaver', '6875 Carpenter Drive', 1860.71, 'Patentino muletto'),
			('55-6849214', 5, 'Christine', 'Burke', '97382 Crest Line Point', 1261.74, 'Mezzi Pesanti'),
			('21-3003316', 6, 'Shirley', 'Bowman', '11 Talmadge Lane', 1631.26, null),
			('14-1271775', 7, 'Louis', 'Mitchell', '38216 Northview Plaza', 2734.97, 'Sostanze Pericolose'),
			('16-9004485', 8, 'Amy', 'Gibson', '5 Golf Alley', 1607.97, 'Sostanze Pericolose'),
			('47-6258008', 9, 'Edward', 'Fisher', '6182 Fisk Way', 1444.51, null),
			('19-5619122', 10, 'Heather', 'Martin', '09 Redwing Park', 1859.42, 'Sostanze Pericolose'),
			('30-5517849', 1, 'Benjamin', 'Alexander', '8 Arapahoe Place', 1555.83, 'Mezzi Pesanti'),
			('57-3332996', 2, 'Rose', 'Watson', '2575 Banding Junction', 2405.29, 'Sostanze Pericolose'),
			('62-3228022', 3, 'Craig', 'Weaver', '3 Sommers Junction', 1904.65, 'Conducente Camion'),
			('55-7482611', 4, 'Rose', 'Rivera', '97782 Loftsgordon Pass', 2601.05, 'Patentino muletto'),
			('24-8570609', 5, 'Earl', 'Roberts', '26 Colorado Plaza', 2488.33, 'Patentino muletto'),
			('18-5470927', 6, 'Heather', 'Ramos', '293 Buell Court', 1562.48, 'Conducente Camion'),
			('80-2989403', 7, 'Peter', 'Larson', '351 Esker Point', 1875.12, 'Sostanze Pericolose'),
			('10-4385820', 8, 'Patrick', 'Reid', '757 5th Junction', 1652.2, 'Mezzi Pesanti'),
			('76-8850298', 9, 'Ryan', 'Moore', '4874 Moose Place', 2711.56, 'Sostanze Pericolose'),
			('49-6813755', 10, 'Terry', 'Carroll', '62 Banding Plaza', 1777.59, 'Sostanze Pericolose');
            
            
insert into Serra (Codice, Sede, Nome, Indirizzo, NumPianteMax, X, Y, Z) 
	values  (1, 1, 'Vacallo	Vercoglia di Cosbana', 'Via dei Pini 12', 2276, 127, 79, 127),
			(2, 2, 'Cremenaga', 'Via Cavour 87', 2326, 85, 57, 96),
			(3, 3, 'Rancina', 'Via Garibaldi 17', 1725, 92, 162, 52),
			(4, 4, 'San Simone', 'Via dei Salici 14', 2168, 175, 95, 118),
			(5, 5, 'Alpe Cottino', 'Via delle Betulle 13', 1899, 88, 115, 57),
			(6, 6, 'Giordano', 'Via dei Pini 12', 1925, 138, 129, 75),
			(7, 7, 'Tiradelza', 'Via Cavour 87', 2176, 163, 90, 151),
			(8, 8, 'Alpe Cottino', 'Via Mazzini 16', 2017, 144, 157, 176),
			(9, 9, 'Roggiana', 'Via dei Pini 12', 1624, 66, 134, 159),
			(10, 10, 'Regina', 'Viale della Repubblica 121', 2087, 180, 159, 159),
			(11, 1, 'Cerò di Sotto', 'Viale della Repubblica 121', 2182, 172, 195, 118),
			(12, 3, 'Trobina', 'Via Napoleone Bonaparte 18', 1682, 100, 132, 196),
			(13, 5, 'Seseglio', 'Via Garibaldi 17', 1687, 135, 90, 91),
			(14, 7, 'Castelletto Zeglo', 'Via dei Tulipani 15', 1669, 50, 90, 56),
			(15, 9, 'Plešivo', 'Via dei Salici 14', 1874, 103, 96, 179);
            
            
            
insert into Sezione (Codice, Serra, Temperatura, Umidita, Illuminazione)
	values  (1, 1, 25.3, 20.85, 'Alta'),
			(2, 2, 24.07, 11.77, 'Alta'),
			(3, 3, 19.16, 16.89, 'Media'),
			(4, 4, 22.55, 58.29, 'Alta'),
			(5, 5, 21.43, 26.21, 'Bassa'),
			(6, 6, 23.58, 59.88, 'Media'),
			(7, 7, 19.1, 96.41, 'Alta'),
			(8, 8, 19.8, 55.3, 'Media'),
			(9, 9, 25.23, 32.91, 'Bassa'),
			(10, 10, 20.83, 42.67, 'Bassa'),
            (11, 11, 21.28, 77.58, 'Media'),
            (12, 12, 19.94, 66.65, 'Media'),
            (13, 13, 20.12, 64.53, 'Alta'),
            (14, 14, 25.45, 59.9, 'Bassa'),
            (15, 15, 24.78, 26.0, 'Alta');
            
            
insert into Ripiano (Codice, Sezione, Irrigazione)
	values  (1, 1, 'Alta'),
			(2, 2, 'Bassa'),
			(3, 3, 'Bassa'),
			(4, 4, 'Media'),
			(5, 5, 'Alta'),
			(6, 6, 'Alta'),
			(7, 7, 'Bassa'),
			(8, 8, 'Bassa'),
			(9, 9, 'Bassa'),
			(10, 10, 'Bassa'),
			(11, 11, 'Media'),
			(12, 12, 'Media'),
			(13, 13, 'Bassa'),
			(14, 14, 'Alta'),
			(15, 15, 'Media'),
			(16, 1, 'Alta'),
			(17, 2, 'Alta'),
			(18, 3, 'Media'),
			(19, 4, 'Alta'),
			(20, 5, 'Alta'),
			(21, 6, 'Bassa'),
			(22, 7, 'Bassa'),
			(23, 8, 'Bassa'),
			(24, 9, 'Alta'),
			(25, 10, 'Alta'),
			(26, 11, 'Alta'),
			(27, 12, 'Alta'),
			(28, 13, 'Alta'),
			(29, 14, 'Bassa'),
			(30, 15, 'Media');
            
            
            
insert into Contenitore (Codice, Pianta, Ripiano, Idratazione, Dimensione, ConsistenzaSubstrato, PermeabilitaTerreno) 
	values  (1, null, 1, 82.65, 'Piccola', null, null),
			(2, null, 2, 32.73, 'Piccola', null, null),
			(3, null, 3, 66.45, 'Piccola', null, null),
			(4, null, 4, 43.69, 'Piccola', null, null),
			(5, null, 5, 28.97, 'Piccola', null, null),
			(6, null, 6, 73.22, 'Piccola', null, null),
			(7, null, 7, 75.4, 'Piccola', null, null),
			(8, null, 8, 66.13, 'Piccola', null, null),
			(9, null, 9, 56.54, 'Piccola', null, null),
			(10, null, 10, 36.97, 'Piccola', null, null),
			(11, null, 11, 96.77, 'Piccola', null, null),
			(12, null, 12, 91.0, 'Piccola', null, null),
			(13, null, 13, 11.6, 'Piccola', null, null),
			(14, null, 14, 78.71, 'Piccola', null, null),
			(15, null, 15, 42.86, 'Piccola', null, null),
			(16, null, 16, 24.04, 'Piccola', null, null),
			(17, null, 17, 76.81, 'Piccola', null, null),
			(18, null, 18, 47.2, 'Piccola', null, null),
			(19, null, 19, 49.61, 'Piccola', null, null),
			(20, null, 20, 90.66, 'Piccola', null, null),
			(21, null, 21, 61.57, 'Piccola', null, null),
			(22, null, 22, 23.57, 'Piccola', null, null),
			(23, null, 23, 48.81, 'Piccola', null, null),
			(24, null, 24, 36.16, 'Piccola', null, null),
			(25, null, 25, 3.61, 'Piccola', null, null),
			(26, null, 26, 12.2, 'Piccola', null, null),
			(27, null, 27, 61.9, 'Piccola', null, null),
			(28, null, 28, 81.52, 'Piccola', null, null),
			(29, null, 29, 28.28, 'Piccola', null, null),
			(30, null, 30, 29.57, 'Piccola', null, null),
            (31, null, 1, 82.65, 'Media', null, null),
			(32, null, 2, 32.73, 'Media', null, null),
			(33, null, 3, 66.45, 'Media', null, null),
			(34, null, 4, 43.69, 'Media', null, null),
			(35, null, 5, 28.97, 'Media', null, null),
			(36, null, 6, 73.22, 'Media', null, null),
			(37, null, 7, 75.4, 'Media', null, null),
			(38, null, 8, 66.13, 'Media', null, null),
			(39, null, 9, 56.54, 'Media', null, null),
			(40, null, 10, 36.97, 'Media', null, null),
			(41, null, 11, 96.77, 'Media', null, null),
			(42, null, 12, 91.0, 'Media', null, null),
			(43, null, 13, 11.6, 'Media', null, null),
			(44, null, 14, 78.71, 'Media', null, null),
			(45, null, 15, 42.86, 'Media', null, null),
			(46, null, 16, 24.04, 'Media', null, null),
			(47, null, 17, 76.81, 'Media', null, null),
			(48, null, 18, 47.2, 'Media', null, null),
			(49, null, 19, 49.61, 'Media', null, null),
			(50, null, 20, 90.66, 'Media', null, null),
			(51, null, 21, 61.57, 'Media', null, null),
			(52, null, 22, 23.57, 'Media', null, null),
			(53, null, 23, 48.81, 'Media', null, null),
			(54, null, 24, 36.16, 'Media', null, null),
			(55, null, 25, 3.61, 'Media', null, null),
			(56, null, 26, 12.2, 'Media', null, null),
			(57, null, 27, 61.9, 'Media', null, null),
			(58, null, 28, 81.52, 'Media', null, null),
			(59, null, 29, 28.28, 'Media', null, null),
			(60, null, 30, 29.57, 'Media', null, null),
			(61, null, 1, 82.65, 'Grande', null, null),
			(62, null, 2, 32.73, 'Grande', null, null),
			(63, null, 3, 66.45, 'Grande', null, null),
			(64, null, 4, 43.69, 'Grande', null, null),
			(65, null, 5, 28.97, 'Grande', null, null),
			(66, null, 6, 73.22, 'Grande', null, null),
			(67, null, 7, 75.4, 'Grande', null, null),
			(68, null, 8, 66.13, 'Grande', null, null),
			(69, null, 9, 56.54, 'Grande', null, null),
			(70, null, 10, 36.97, 'Grande', null, null),
			(71, null, 11, 96.77, 'Grande', null, null),
			(72, null, 12, 91.0, 'Grande', null, null),
			(73, null, 13, 11.6, 'Grande', null, null),
			(74, null, 14, 78.71, 'Grande', null, null),
			(75, null, 15, 42.86, 'Grande', null, null),
			(76, null, 16, 24.04, 'Grande', null, null),
			(77, null, 17, 76.81, 'Grande', null, null),
			(78, null, 18, 47.2, 'Grande', null, null),
			(79, null, 19, 49.61, 'Grande', null, null),
			(80, null, 20, 90.66, 'Grande', null, null),
			(81, null, 21, 61.57, 'Grande', null, null),
			(82, null, 22, 23.57, 'Grande', null, null),
			(83, null, 23, 48.81, 'Grande', null, null),
			(84, null, 24, 36.16, 'Grande', null, null),
			(85, null, 25, 3.61, 'Grande', null, null),
			(86, null, 26, 12.2, 'Grande', null, null),
			(87, null, 27, 61.9, 'Grande', null, null),
			(88, null, 28, 81.52, 'Grande', null, null),
			(89, null, 29, 28.28, 'Grande', null, null),
			(90, null, 30, 29.57, 'Grande', null, null);
/*
DROP TABLE IF EXISTS ContenitoriVuoti;
CREATE TABLE ContenitoriVuoti AS
	(
	SELECT C1.Codice AS CodiceContenitore, SE1.Codice AS CodiceSerra
	FROM Contenitore C1
		INNER JOIN Ripiano R1 on R1.Codice = C1.Ripiano
		INNER JOIN Sezione S1 on S1.Codice = R1.Sezione
		INNER JOIN Serra SE1 on SE1.Codice = S1.Serra
	WHERE C1.Pianta IS NULL
	);
 */   
DROP TRIGGER IF EXISTS TrovaContenitore;

DELIMITER $$
CREATE TRIGGER TrovaContenitore
AFTER INSERT ON Pianta
FOR EACH ROW
BEGIN
	
	SET @serra = NEW.Serra;
    SET @pianta = NEW.Codice;
	IF EXISTS (
				SELECT * FROM 
					(
					SELECT C1.Codice AS CodiceContenitore, SE1.Codice AS CodiceSerra
					FROM Contenitore C1
						INNER JOIN Ripiano R1 on R1.Codice = C1.Ripiano
						INNER JOIN Sezione S1 on S1.Codice = R1.Sezione
						INNER JOIN Serra SE1 on SE1.Codice = S1.Serra
						WHERE C1.Pianta IS NULL 
					) AS ContenitoriVuoti
					WHERE CodiceSerra = @serra
				)
	THEN
		SET @codContenitore = (
								SELECT CodiceContenitore 
								FROM
								(
									SELECT C1.Codice AS CodiceContenitore, SE1.Codice AS CodiceSerra
									FROM Contenitore C1
										INNER JOIN Ripiano R1 on R1.Codice = C1.Ripiano
										INNER JOIN Sezione S1 on S1.Codice = R1.Sezione
										INNER JOIN Serra SE1 on SE1.Codice = S1.Serra
									WHERE C1.Pianta IS NULL 
								) AS ContenitoriVuoti2
                                WHERE CodiceSerra = @serra
                                LIMIT 1
                                );
	UPDATE Contenitore
	SET Contenitore.Pianta = @pianta
	WHERE Contenitore.Codice = @codContenitore;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nessun contenitore vuoto!';
	END IF;
END$$
DELIMITER ;	


insert into Pianta (Codice, CatalogoPiante, Serra, Sesso, DimAttuale) 
	values  (1, 1, 1, 'M', 'Media'),
			(2, 2, 2, 'F', 'Media'),
			(3, 3, 3, 'F', 'Media'),
			(4, 4, 4, 'F', 'Media'),
			(5, 5, 5, 'M', 'Piccola'),
			(6, 6, 6, 'F', 'Piccola'),
			(7, 7, 7, 'F', 'Media'),
			(8, 8, 8, 'F', 'Media'),
			(9, 9, 9, 'M', 'Piccola'),
			(10, 10, 10, 'M', 'Media'),
			(11, 11, 11, 'M', 'Piccola'),
			(12, 12, 12, 'M', 'Media'),
			(13, 13, 13, 'M', 'Piccola'),
			(14, 14, 14, 'M', 'Media'),
			(15, 15, 15, 'F', 'Media'),
			(16, 1, 1, 'M', 'Media'),
			(17, 2, 2, 'M', 'Piccola'),
			(18, 3, 3, 'M', 'Media'),
			(19, 4, 4, 'M', 'Media'),
			(20, 5, 5, 'F', 'Media'),
			(21, 6, 6, 'F', 'Piccola'),
			(22, 7, 7, 'F', 'Piccola'),
			(23, 8, 8, 'F', 'Media'),
			(24, 9, 9, 'F', 'Media'),
			(25, 10, 10, 'M', 'Media'),
			(26, 11, 1, 'M', 'Media'),
			(27, 12, 12, 'M', 'Media'),
			(28, 13, 13, 'F', 'Piccola'),
			(29, 14, 14, 'F', 'Piccola'),
			(30, 15, 15, 'F', 'Media'),
			(31, 1, 1, 'F', 'Grande'),
			(32, 2, 2, 'M', 'Piccola'),
			(33, 3, 3, 'F', 'Piccola'),
			(34, 4, 4, 'F', 'Grande'),
			(35, 5, 5, 'F', 'Grande'),
			(36, 6, 6, 'F', 'Piccola'),
			(37, 7, 7, 'M', 'Grande'),
			(38, 8, 8, 'F', 'Piccola'),
			(39, 9, 9, 'M', 'Grande'),	
			(40, 10, 10, 'F', 'Piccola'),
			(41, 1, 11, 'F', 'Piccola'),
			(42, 12, 12, 'F', 'Grande'),
			(43, 13, 13, 'F', 'Piccola'),
			(44, 14, 14, 'F', 'Grande'),
			(45, 15, 15, 'F', 'Piccola'),
			(46, 1, 1, 'F', 'Grande'),
			(47, 2, 2, 'M', 'Piccola'),
			(48, 3, 3, 'F', 'Piccola'),
			(49, 4, 4, 'F', 'Grande'),
			(50, 5, 5, 'F', 'Grande'),
			(51, 6, 6, 'F', 'Grande'),
			(52, 7, 7, 'F', 'Grande'),
			(53, 8, 8, 'F', 'Grande'),
			(54, 9, 9, 'F', 'Grande'),
			(55, 10, 10, 'F', 'Grande'),
			(56, 11, 11, 'M', 'Grande'),
			(57, 12, 12, 'M', 'Grande'),
			(58, 13, 13, 'M', 'Grande'),
			(59, 14, 14, 'F', 'Grande'),
			(60, 15, 15, 'M', 'Grande');

insert into Esigenze (CatalogoPiante, Consistenza, Permeabilita, IrrigazioniRiposoSettimanali, IrrigazioniVegetativoSettimanali, TempMax, TempMin, OreLuceVeg, OreLuceRip, LuceDiretta, QuantitaLuce, PH) 
	values  (1, null, null, 4, 6, 38, 18, 8, 4, false, 'Alta', 7.6),
			(2, null, null, 3, 9, 35, 10, 10, 3, true, 'Bassa', 1.6),
			(3, null, null, 3, 10, 37, 10, 9, 4, true, 'Alta', 10.5),
			(4, null, null, 1, 10, 39, 9, 10, 1, false, 'Alta', 4.9),
			(5, null, null, 2, 6, 39, 14, 10, 1, true, 'Bassa', 6.8),
			(6, null, null, 5, 9, 37, 12, 7, 5, true, 'Media', 10.4),
			(7, null, null, 3, 6, 35, 18, 5, 3, true, 'Media', 11.3),
			(8, null, null, 5, 7, 37, 13, 10, 0, true, 'Bassa', 6.6),
			(9, null, null, 2, 6, 35, 14, 9, 4, true, 'Media', 0.4),
			(10, null, null, 2, 9, 40, 9, 8, 5, false, 'Media', 8.0),
			(11, null, null, 1, 6, 38, 16, 7, 5, true, 'Media', 9.1),
			(12, null, null, 2, 9, 38, 10, 8, 4, true, 'Alta', 4.3),
			(13, null, null, 0, 9, 36, 16, 10, 1, false, 'Alta', 2.2),
			(14, null, null, 0, 9, 36, 14, 8, 6, false, 'Alta', 3.3),
			(15, null, null, 1, 9, 35, 8, 8, 6, true, 'Media', 12.1);
            
            
INSERT INTO Elemento
VALUES
	('Azoto','Microelemento'),
    ('Potassio','Microelemento'),
    ('Fosforo','Microelemento'),
    ('Calcio','Microelemento'),
    ('Ferro','Microelemento'),
    ('Magnesio','Microelemento'),
    ('Zolfo','Microelemento'),
    ('Rame','Microelemento'),
    ('Cloro','Microelemento'),
    ('Boro','Microelemento'),
    ('Zinco','Microelemento'),
    ('Manganese','Microelemento'),
    ('Molibdeno','Microelemento'),
    ('Chelato di Ferro','Rinverdente'),
    ('Nitrato di Potassio','Concime');
    
    
insert into Farmaco (Codice, NomeCommerciale, Tipologia) 
	values  (1, 'ENOVIT', 'Ampio Spettro'),
			(2, 'CONTRAX STANGE', 'Ampio Spettro'),
			(3, 'QUINTAMON', 'Selettivo'),
			(4, 'AGROXONE 96', 'Selettivo'),
			(5, 'TMTD-AMONN', 'Ampio Spettro'),
			(6, 'ZIRAM 80', 'Selettivo'),
			(7, 'DDT 50 WP', 'Selettivo'),
			(8, 'ENTOX 10 POLVERE', 'Ampio Spettro'),
			(9, 'AGROXONE C', 'Ampio Spettro'),
			(10, 'ALGACIDE', 'Selettivo');
            
            
insert into PrincipioAttivo (Nome) 
	values  ('THIOPHANATE-METHYL'),
			('WARFARIN'),
			('DICLORAN'),
			('MCPA'),
			('THIRAM'),
			('ZIRAM'),
			('DDT'),
			('ALDRIN'),
			('COPPER CHLORIDE (RAME CLORURO)'),
			('SULPHUR (ZOLFO)'),
			('ANTRACHINONE'),
			('METOBROMURON'),
			('PERTANE'),
			('DICHLORPROP'),
			('DICOFOL|DINOCAP'),
			('ARSENIC ANHYDRIDE (ANIDRIDE ARSENICA)'),
			('DIAZINON'),
			('ZINEB'),
			('METAM SODIUM'),
			('DINOCAP'),
			('FOLPET|MANCOZEB'),
			('DDD'),
			('ATRAZINE'),
			('CARBARIL'),
			('ENDOSULFAN'),
			('LINDANE (LINDANO)'),
			('DALAPON'),
			('SORBITAN MONOLEATO'),
			('HEXACHLOROBENZENE'),
			('COPPER OXYCHLORIDE (RAME OSSICLORURO)'),
			('MALATHION');
            
            
insert into Formulazione (PrincipioAttivo, Farmaco, Concentrazione) 
	values  ('HEXACHLOROBENZENE', 1, 80),
			('ANTRACHINONE', 2, 80),
			('THIRAM', 3, 80),
			('THIRAM', 4, 80),
			('CARBARIL', 5, 80),
			('COPPER CHLORIDE (RAME CLORURO)', 6, 80),
			('ZINEB', 7, 80),
			('LINDANE (LINDANO)', 8, 80),
			('ZIRAM', 9, 80),
			('DDD', 10, 80);
            
            
insert into Patologia (Nome, Descrizione, AgentePatogeno) 
	values  ('Acremonium strictum', 'nulla integer pede justo lacinia eget tincidunt eget tempus vel', 'Insetti'),
			('Alternaria alternata f.sp. cucurbitae', 'sollicitudin ut suscipit a', 'Insetti'),
			('Alternaria alternata f.sp. fragariae', 'consequat varius integer ac leo', 'Funghi'),
			('Alternaria alternata f.sp. lycopersici', 'at vulputate vitae nisl aenean lectus pellentesque', 'Parassiti'),
			('Alternaria arachidis', 'imperdiet sapien urna pretium nisl', 'Parassiti'),
			('Alternaria cucumerina', 'et magnis dis parturient montes nascetur ridiculus mus', 'Parassiti'),
			('Alternaria sonchi', 'augue a suscipit nulla elit ac', 'Virus'),
			('Aphelenchoides coffeae', 'gravida sem praesent id', 'Batteri'),
			('Apiognomonia veneta', 'sapien placerat ante nulla justo', 'Nematodi'),
			('Legno nero', 'eget congue eget semper rutrum nulla nunc purus phasellus', 'Funghi');
            

insert into PeriodoFruttificazione (ID, CatalogoPiante, MeseInizio, MeseFine) 
	values  (1, 1, 4, 7),
			(2, 2, 5, 7),
			(3, 3, 3, 7),
			(4, 4, 3, 6),
			(5, 5, 4, 5),
			(6, 6, 4, 6),
			(7, 7, 4, 5),
			(8, 8, 5, 6),
			(9, 9, 5, 7),
			(10, 10, 5, 6),
			(11, 11, 4, 6),
			(12, 12, 3, 6),
			(13, 13, 5, 7),
			(14, 14, 3, 7),
			(15, 15, 5, 7),
			(16, 1, 3, 5),
			(17, 2, 3, 5),
			(18, 3, 5, 5),
			(19, 4, 3, 6),
			(20, 5, 5, 5),
			(21, 6, 5, 5),
			(22, 7, 5, 7),
			(23, 8, 4, 7),
			(24, 9, 4, 7),
			(25, 10, 5, 6),
			(26, 11, 5, 7),
			(27, 12, 4, 6),
			(28, 13, 3, 7),
			(29, 14, 4, 7),
			(30, 15, 5, 7);
            

INSERT INTO Sintomo
VALUES 
	(1,'Ingiallimento foglie'),
	(2,'Marcescenza foglie'),
    (3,'Ingiallimento tronco'),
    (4,'Afflosciamento'),
    (5,'Perdita prematura di foglie'),
    (6,'Rinsecchimento'),
    (7,'Macchie bianche'),
    (8,'Macchie nere piccole'),
    (9,'Macchie nere medie'),
    (10,'Muffe'),
    (11,'Fori nelle foglie'),
    (12,'Presenza di insetti');
    
    
insert into Indicazione (ID, Patologia, Farmaco, Somministrazione, Dosaggio) 
	values  (1, 'Acremonium strictum', 1, 'Terreno', 796.53),
			(2, 'Alternaria alternata f.sp. cucurbitae', 2, 'Terreno', 789.65),
			(3, 'Alternaria alternata f.sp. fragariae', 3, 'Nebulizzazione', 835.09),
			(4, 'Alternaria alternata f.sp. lycopersici', 4, 'Nebulizzazione', 837.53),
			(5, 'Alternaria arachidis', 5, 'Terreno', 51.8),
			(6, 'Alternaria cucumerina', 6, 'Nebulizzazione', 956.03),
			(7, 'Alternaria sonchi', 7, 'Spruzzatura', 794.68),
			(8, 'Aphelenchoides coffeae', 8, 'Nebulizzazione', 958.59),
			(9, 'Apiognomonia veneta', 9, 'Terreno', 470.88),
			(10, 'Legno nero', 10, 'Nebulizzazione', 948.83);
            
            
            
INSERT INTO Terreno 
VALUES 
	('Argilla'),('Sabbia'),('Torba'),('Ghiaia'),('Compost'),('Terriccio'),('Limo');
    
    
insert into Risorse (Codice, Nome) 
	values  (1, 'Camion 6T'),
			(2, 'Sacco di torba 25KG'),
			(3, 'Sacco di ghiaia 25KG'),
			(4, 'Sacco di sabbia 25KG'),
			(5, 'Sacco di limo 25KG'),
			(6, 'Sacco di terriccio 25KG'),
			(7, 'Pala grande'),
			(8, 'Rastrello grande'),
			(9, 'Scala 10m pieghevole'),
			(10, 'Scala 5m pieghevole'),
			(11, 'Borsa attrezzi'),
			(12, 'Tubo flessibile'),
			(13, 'Compressore 25L'),
			(14, 'Compressore 50L'),
			(15, 'Nebulizzatore insetticida'),
			(16, 'Nebulizzatore generico'),
			(17, 'Furgone 2T'),
			(18, 'Furgone 3.5T'),
			(19, 'Spatola'),
			(20, 'Cesoie'),
			(21, 'Tosaerba'),
			(22, 'Guanti da lavoro'),
			(23, 'Miscela Concime ALFA'),
			(24, 'Miscela Concime BETA'),
			(25, 'Miscela Concime GAMMA'),
			(26, 'Vaso grande'),
			(27, 'Vaso medio'),
			(28, 'Vaso piccolo');
            
            
insert into Causa (Sintomo, Patologia) 
	values  (1, 'Acremonium strictum'),
			(2, 'Alternaria alternata f.sp. cucurbitae'),
			(3, 'Alternaria alternata f.sp. fragariae'),
			(4, 'Alternaria alternata f.sp. lycopersici'),
			(5, 'Alternaria arachidis'),
			(6, 'Alternaria cucumerina'),
			(7, 'Alternaria sonchi'),
			(8, 'Aphelenchoides coffeae'),
			(9, 'Apiognomonia veneta'),
			(10, 'Legno nero'),
			(11, 'Botryosphaeria ribis'),
			(12, 'Carpellodia'),
			(1, 'Cuore cavo'),
			(2, 'Cuore nero'),
			(3, 'Mal dell''inchiostro'),
			(4, 'Malattia di Pierce'),
			(5, 'Puccinia graminis'),
			(6, 'Sharka'),
			(7, 'Xylella fastidiosa'),
			(8, 'Puccinia enixa'),
			(9, 'Puccinia enneapogonis'),
			(10, 'Puccinia enteropogonis'),
			(11, 'Puccinia entrerriana'),
			(12, 'Puccinia eragrostidicola'),
			(1, 'Puccinia eragrostidis'),
			(2, 'Puccinia eragrostidis-superbae'),
			(3, 'Puccinia eragrostis-arundinaceae'),
			(4, 'Puccinia erianthicola'),
			(5, 'Puccinia eritraeensis'),
			(6, 'Puccinia erratica'),
			(7, 'Puccinia erythrophus'),
			(8, 'Puccinia esclavensis'),
			(9, 'Puccinia espinosarum'),
			(10, 'Puccinia eucomi'),
			(11, 'Puccinia eupatorii'),
			(12, 'Puccinia evadens');



insert into ComposizioneChimica (Elemento, Dose, Contenitore) 
	values ('Azoto', 85.18, 1),
('Potassio', 4.34, 2),
('Fosforo', 1.84, 3),
('Calcio', 4.55, 4),
('Ferro', 1.83, 5),
('Magnesio', 2.89, 6),
('Zolfo', 4.75, 7),
('Rame', 3.11, 8),
('Cloro', 2.41, 9),
('Boro', 1.81, 10),
('Zinco', 2.55, 11),
('Manganese', 3.4, 12),
('Molibdeno', 1.58, 13),
('Chelato di Ferro', 4.68, 14),
('Nitrato di Potassio', 4.58, 15),
('Azoto', 2.12, 16),
('Potassio', 2.1, 17),
('Fosforo', 1.94, 18),
('Calcio', 2.84, 19),
('Ferro', 1.42, 20),
('Magnesio', 1.77, 21),
('Zolfo', 1.37, 22),
('Rame', 2.69, 23),
('Cloro', 2.53, 24),
('Boro', 4.21, 25),
('Zinco', 2.54, 26),
('Manganese', 4.04, 27),
('Molibdeno', 2.7, 28),
('Chelato di Ferro', 3.3, 29),
('Nitrato di Potassio', 2.27, 30),
('Azoto', 4.13, 31),
('Potassio', 1.05, 32),
('Fosforo', 2.58, 33),
('Calcio', 4.98, 34),
('Ferro', 3.8, 35),
('Magnesio', 2.91, 36),
('Zolfo', 4.48, 37),
('Rame', 1.43, 38),
('Cloro', 1.5, 39),
('Boro', 2.21, 40),
('Zinco', 1.13, 41),
('Manganese', 3.54, 42),
('Molibdeno', 1.0, 43),
('Chelato di Ferro', 2.99, 44),
('Nitrato di Potassio', 1.67, 45),
('Azoto', 3.74, 46),
('Potassio', 2.17, 47),
('Fosforo', 4.24, 48),
('Calcio', 1.5, 49),
('Ferro', 2.23, 50),
('Magnesio', 1.31, 51),
('Zolfo', 3.32, 52),
('Rame', 2.53, 53),
('Cloro', 1.04, 54),
('Boro', 2.03, 55),
('Zinco', 3.33, 56),
('Manganese', 2.55, 57),
('Molibdeno', 3.3, 58),
('Chelato di Ferro', 1.83, 59),
('Nitrato di Potassio', 2.29, 60),
('Azoto', 4.6, 61),
('Potassio', 1.62, 62),
('Fosforo', 1.93, 63),
('Calcio', 3.71, 64),
('Ferro', 2.09, 65),
('Magnesio', 3.36, 66),
('Zolfo', 3.01, 67),
('Rame', 1.92, 68),
('Cloro', 2.09, 69),
('Boro', 1.39, 70),
('Zinco', 2.66, 71),
('Manganese', 1.35, 72),
('Molibdeno', 3.79, 73),
('Chelato di Ferro', 3.89, 74),
('Nitrato di Potassio', 1.94, 75),
('Azoto', 1.47, 76),
('Potassio', 3.88, 77),
('Fosforo', 2.6, 78),
('Calcio', 1.84, 79),
('Ferro', 3.91, 80),
('Magnesio', 4.69, 81),
('Zolfo', 4.31, 82),
('Rame', 2.57, 83),
('Cloro', 4.13, 84),
('Boro', 2.87, 85),
('Zinco', 3.03, 86),
('Manganese', 1.83, 87),
('Molibdeno', 1.43, 88),
('Chelato di Ferro', 3.7, 89),
('Nitrato di Potassio', 1.81, 90),
('Azoto', 3.02, 2),
('Potassio', 3.16, 3),
('Fosforo', 3.17, 4),
('Calcio', 1.23, 5),
('Ferro', 3.96, 6),
('Magnesio', 4.7, 7),
('Zolfo', 3.53, 8),
('Rame', 2.26, 9),
('Cloro', 4.14, 10),
('Boro', 1.59, 11),
('Zinco', 3.71, 12),
('Manganese', 1.6, 13),
('Molibdeno', 2.3, 14),
('Chelato di Ferro', 1.21, 15),
('Nitrato di Potassio', 1.66, 16),
('Azoto', 3.25, 17),
('Potassio', 3.0, 18),
('Fosforo', 3.57, 19),
('Calcio', 3.92, 20),
('Ferro', 1.88, 21),
('Magnesio', 2.17, 22),
('Zolfo', 2.87, 23),
('Rame', 3.84, 24),
('Cloro', 1.03, 25),
('Boro', 1.87, 26),
('Zinco', 3.98, 27),
('Manganese', 3.54, 28),
('Molibdeno', 3.47, 29),
('Chelato di Ferro', 3.2, 30),
('Nitrato di Potassio', 3.28, 31),
('Azoto', 1.54, 32),
('Potassio', 2.89, 33),
('Fosforo', 4.71, 34),
('Calcio', 1.03, 35),
('Ferro', 3.47, 36),
('Magnesio', 4.3, 37),
('Zolfo', 1.65, 38),
('Rame', 1.6, 39),
('Cloro', 3.56, 40),
('Boro', 4.22, 41),
('Zinco', 2.78, 42),
('Manganese', 3.44, 43),
('Molibdeno', 2.41, 44),
('Chelato di Ferro', 3.62, 45),
('Nitrato di Potassio', 4.4, 46),
('Azoto', 2.92, 47),
('Potassio', 3.17, 48),
('Fosforo', 4.55, 49),
('Calcio', 4.83, 50),
('Ferro', 3.15, 51),
('Magnesio', 1.21, 52),
('Zolfo', 4.59, 53),
('Rame', 4.36, 54),
('Cloro', 1.98, 55),
('Boro', 3.09, 56),
('Zinco', 3.26, 57),
('Manganese', 3.13, 58),
('Molibdeno', 1.04, 59),
('Chelato di Ferro', 2.27, 60),
('Nitrato di Potassio', 2.8, 61),
('Azoto', 4.3, 62),
('Potassio', 3.18, 63),
('Fosforo', 2.93, 64),
('Calcio', 3.7, 65),
('Ferro', 3.5, 66),
('Magnesio', 1.64, 67),
('Zolfo', 3.82, 68),
('Rame', 4.51, 69),
('Cloro', 4.66, 70),
('Boro', 2.58, 71),
('Zinco', 1.88, 72),
('Manganese', 2.8, 73),
('Molibdeno', 4.23, 74),
('Chelato di Ferro', 1.63, 75),
('Nitrato di Potassio', 2.27, 76),
('Azoto', 4.47, 77),
('Potassio', 2.62, 78),
('Fosforo', 3.6, 79),
('Calcio', 3.7, 80),
('Ferro', 1.66, 81),
('Magnesio', 2.21, 82),
('Zolfo', 1.22, 83),
('Rame', 2.86, 84),
('Cloro', 3.65, 85),
('Boro', 2.4, 86),
('Zinco', 3.81, 87),
('Manganese', 1.62, 88),
('Molibdeno', 1.4, 89),
('Chelato di Ferro', 3.14, 90),
('Azoto', 3.09, 3),
('Potassio', 1.79, 4),
('Fosforo', 3.04, 5),
('Calcio', 1.73, 6),
('Ferro', 2.98, 7),
('Magnesio', 2.94, 8),
('Zolfo', 3.95, 9),
('Rame', 3.41, 10),
('Cloro', 4.81, 11),
('Boro', 3.19, 12),
('Zinco', 3.29, 13),
('Manganese', 1.01, 14),
('Molibdeno', 3.5, 15),
('Chelato di Ferro', 1.62, 16),
('Nitrato di Potassio', 4.82, 17),
('Azoto', 2.69, 18),
('Potassio', 3.19, 19),
('Fosforo', 4.25, 20),
('Calcio', 1.93, 21),
('Ferro', 1.86, 22),
('Magnesio', 2.8, 23),
('Zolfo', 3.96, 24),
('Rame', 4.96, 25),
('Cloro', 1.87, 26),
('Boro', 3.1, 27),
('Zinco', 4.4, 28),
('Manganese', 3.83, 29),
('Molibdeno', 1.13, 30),
('Chelato di Ferro', 4.48, 31),
('Nitrato di Potassio', 1.91, 32),
('Azoto', 3.37, 33),
('Potassio', 2.94, 34),
('Fosforo', 3.49, 35),
('Calcio', 2.32, 36),
('Ferro', 4.43, 37),
('Magnesio', 4.51, 38),
('Zolfo', 1.33, 39),
('Rame', 3.07, 40),
('Cloro', 4.03, 41),
('Boro', 4.48, 42),
('Zinco', 4.75, 43),
('Manganese', 3.45, 44),
('Molibdeno', 1.11, 45),
('Chelato di Ferro', 3.83, 46),
('Nitrato di Potassio', 1.46, 47),
('Azoto', 4.5, 48),
('Potassio', 1.28, 49),
('Fosforo', 3.45, 50),
('Calcio', 4.41, 51),
('Ferro', 4.65, 52),
('Magnesio', 1.21, 53),
('Zolfo', 4.31, 54),
('Rame', 2.76, 55),
('Cloro', 1.1, 56),
('Boro', 3.39, 57),
('Zinco', 3.17, 58),
('Manganese', 1.79, 59),
('Molibdeno', 2.23, 60),
('Chelato di Ferro', 4.93, 61),
('Nitrato di Potassio', 1.36, 62),
('Azoto', 2.36, 63),
('Potassio', 2.47, 64),
('Fosforo', 1.78, 65),
('Calcio', 3.43, 66),
('Ferro', 1.75, 67),
('Magnesio', 1.94, 68),
('Zolfo', 4.79, 69),
('Rame', 2.77, 70),
('Cloro', 4.83, 71),
('Boro', 2.28, 72),
('Zinco', 2.33, 73),
('Manganese', 1.06, 74),
('Molibdeno', 2.89, 75),
('Chelato di Ferro', 2.17, 76),
('Nitrato di Potassio', 3.13, 77),
('Azoto', 4.84, 78),
('Potassio', 3.56, 79),
('Fosforo', 3.51, 80),
('Calcio', 2.43, 81),
('Ferro', 3.0, 82),
('Magnesio', 1.87, 83),
('Zolfo', 1.63, 84),
('Rame', 3.42, 85),
('Cloro', 3.88, 86),
('Boro', 2.96, 87),
('Zinco', 2.22, 88),
('Manganese', 3.49, 89),
('Molibdeno', 4.78, 90);



insert into ComposizioneSubstrato (Terreno, Percentuale, Contenitore) 
values ('Argilla', 21.99, 3),
('Sabbia', 35.49, 4),
('Torba', 36.34, 5),
('Ghiaia', 34.56, 6),
('Compost', 19.78, 7),
('Terriccio', 67.8, 8),
('Limo', 51.45, 9),
('Argilla', 18.05, 10),
('Sabbia', 18.6, 11),
('Torba', 26.78, 12),
('Ghiaia', 38.83, 13),
('Compost', 64.1, 14),
('Terriccio', 36.89, 15),
('Limo', 39.98, 16),
('Argilla', 32.83, 17),
('Sabbia', 42.76, 18),
('Torba', 43.18, 19),
('Ghiaia', 21.18, 20),
('Compost', 31.19, 21),
('Terriccio', 58.8, 22),
('Limo', 53.74, 23),
('Argilla', 46.5, 24),
('Sabbia', 39.83, 25),
('Torba', 33.7, 26),
('Ghiaia', 66.52, 27),
('Compost', 27.62, 28),
('Terriccio', 19.63, 29),
('Limo', 40.1, 30),
('Argilla', 55.1, 31),
('Sabbia', 61.79, 32),
('Torba', 65.77, 33),
('Ghiaia', 45.78, 34),
('Compost', 36.06, 35),
('Terriccio', 23.64, 36),
('Limo', 53.22, 37),
('Argilla', 56.87, 38),
('Sabbia', 49.8, 39),
('Torba', 52.04, 40),
('Ghiaia', 52.19, 41),
('Compost', 48.27, 42),
('Terriccio', 45.58, 43),
('Limo', 57.48, 44),
('Argilla', 56.45, 45),
('Sabbia', 48.16, 46),
('Torba', 69.92, 47),
('Ghiaia', 37.17, 48),
('Compost', 33.16, 49),
('Terriccio', 47.28, 50),
('Limo', 32.3, 51),
('Argilla', 19.42, 52),
('Sabbia', 37.56, 53),
('Torba', 26.03, 54),
('Ghiaia', 35.84, 55),
('Compost', 56.3, 56),
('Terriccio', 45.82, 57),
('Limo', 58.15, 58),
('Argilla', 61.47, 59),
('Sabbia', 64.17, 60),
('Torba', 26.02, 61),
('Ghiaia', 54.14, 62),
('Compost', 52.56, 63),
('Terriccio', 49.28, 64),
('Limo', 35.79, 65),
('Argilla', 22.35, 66),
('Sabbia', 41.07, 67),
('Torba', 45.46, 68),
('Ghiaia', 61.49, 69),
('Compost', 36.36, 70),
('Terriccio', 23.08, 71),
('Limo', 41.63, 72),
('Argilla', 63.77, 73),
('Sabbia', 24.9, 74),
('Torba', 31.1, 75),
('Ghiaia', 66.4, 76),
('Compost', 66.2, 77),
('Terriccio', 43.24, 78),
('Limo', 65.15, 79),
('Argilla', 30.63, 80),
('Sabbia', 46.6, 81),
('Torba', 23.74, 82),
('Ghiaia', 28.11, 83),
('Compost', 50.4, 84),
('Terriccio', 51.55, 85),
('Limo', 31.6, 86),
('Argilla', 63.88, 87),
('Sabbia', 25.6, 88),
('Torba', 28.89, 89),
('Ghiaia', 64.07, 90),
('Compost', 44.74, 1),
('Terriccio', 46.1, 2),
('Argilla', 9.97, 1),
('Sabbia', 8.65, 2),
('Torba', 5.22, 3),
('Ghiaia', 5.71, 4),
('Compost', 6.47, 5),
('Terriccio', 7.21, 6),
('Limo', 8.81, 7),
('Argilla', 6.78, 8),
('Sabbia', 7.85, 9),
('Torba', 6.95, 10),
('Ghiaia', 9.86, 11),
('Compost', 6.53, 12),
('Terriccio', 7.89, 13),
('Limo', 6.37, 14),
('Argilla', 6.62, 15),
('Sabbia', 7.64, 16),
('Torba', 6.7, 17),
('Ghiaia', 5.11, 18),
('Compost', 5.65, 19),
('Terriccio', 8.95, 20),
('Limo', 9.49, 21),
('Argilla', 6.85, 22),
('Sabbia', 6.11, 23),
('Torba', 9.77, 24),
('Ghiaia', 7.86, 25),
('Compost', 8.14, 26),
('Terriccio', 8.61, 27),
('Limo', 6.56, 28),
('Argilla', 9.98, 29),
('Sabbia', 5.16, 30),
('Torba', 6.62, 31),
('Ghiaia', 8.09, 32),
('Compost', 7.36, 33),
('Terriccio', 8.74, 34),
('Limo', 9.46, 35),
('Argilla', 6.93, 36),
('Sabbia', 8.32, 37),
('Torba', 7.23, 38),
('Ghiaia', 9.23, 39),
('Compost', 8.69, 40),
('Terriccio', 7.55, 41),
('Limo', 6.78, 42),
('Argilla', 8.42, 43),
('Sabbia', 8.16, 44),
('Torba', 6.92, 45),
('Ghiaia', 5.77, 46),
('Compost', 8.39, 47),
('Terriccio', 7.28, 48),
('Limo', 6.15, 49),
('Argilla', 9.71, 50),
('Sabbia', 9.51, 51),
('Torba', 6.23, 52),
('Ghiaia', 8.38, 53),
('Compost', 6.65, 54),
('Terriccio', 6.45, 55),
('Limo', 6.6, 56),
('Argilla', 8.15, 57),
('Sabbia', 7.65, 58),
('Torba', 7.32, 59),
('Ghiaia', 9.43, 60),
('Compost', 5.94, 61),
('Terriccio', 8.55, 62),
('Limo', 7.44, 63),
('Argilla', 8.36, 64),
('Sabbia', 5.29, 65),
('Torba', 9.11, 66),
('Ghiaia', 5.97, 67),
('Compost', 8.32, 68),
('Terriccio', 6.51, 69),
('Limo', 6.86, 70),
('Argilla', 7.18, 71),
('Sabbia', 7.13, 72),
('Torba', 9.07, 73),
('Ghiaia', 9.46, 74),
('Compost', 7.87, 75),
('Terriccio', 7.2, 76),
('Limo', 8.43, 77),
('Argilla', 7.82, 78),
('Sabbia', 9.23, 79),
('Torba', 9.03, 80),
('Ghiaia', 6.96, 81),
('Compost', 8.56, 82),
('Terriccio', 9.61, 83),
('Limo', 7.54, 84),
('Argilla', 6.4, 85),
('Sabbia', 6.58, 86),
('Torba', 6.92, 87),
('Ghiaia', 6.17, 88),
('Compost', 5.66, 89),
('Terriccio', 7.21, 90);


insert into ImmagineCampione (ID, Sintomo, URL) 
values (1, 1, 'http://dummyimage.com/240x130.png/ff4444/ffffff'),
(2, 2, 'http://dummyimage.com/247x142.png/dddddd/000000'),
(3, 3, 'http://dummyimage.com/209x181.png/5fa2dd/ffffff'),
(4, 4, 'http://dummyimage.com/224x100.png/5fa2dd/ffffff'),
(5, 5, 'http://dummyimage.com/209x174.png/5fa2dd/ffffff'),
(6, 6, 'http://dummyimage.com/249x114.png/ff4444/ffffff'),
(7, 7, 'http://dummyimage.com/216x139.png/dddddd/000000'),
(8, 8, 'http://dummyimage.com/245x219.png/5fa2dd/ffffff'),
(9, 9, 'http://dummyimage.com/226x223.png/dddddd/000000'),
(10, 10, 'http://dummyimage.com/242x221.png/ff4444/ffffff'),
(11, 11, 'http://dummyimage.com/242x241.png/5fa2dd/ffffff');



insert into PeriodoManutenzione (CatalogoIntervento, MeseInizio, CatalogoPiante, MeseFine, ID) 
values (1, 5, 1, 11, 1),
(2, 4, 2, 6, 2),
(3, 1, 3, 7, 3),
(4, 3, 4, 6, 4),
(5, 4, 5, 12, 5),
(6, 2, 6, 12, 6),
(7, 3, 7, 8, 7),
(8, 2, 8, 6, 8),
(9, 6, 9, 10, 9),
(1, 1, 10, 7, 10),
(1, 5, 11, 11, 11),
(2, 5, 12, 7, 12),
(3, 2, 13, 12, 13),
(4, 5, 14, 12, 14),
(5, 4, 15, 12, 15),
(1, 6, 2, 12, 16),
(2, 6, 3, 10, 17),
(3, 2, 4, 10, 18),
(4, 6, 5, 12, 19),
(5, 6, 6, 8, 20),
(6, 5, 7, 9, 21),
(7, 2, 8, 8, 22),
(8, 2, 9, 7, 23),
(9, 1, 10, 8, 24),
(1, 5, 11, 11, 25),
(1, 1, 12, 9, 26),
(2, 5, 13, 11, 27),
(3, 6, 14, 10, 28),
(4, 1, 15, 9, 29);



insert into Prezzo (CatalogoPiante, Dimensione, Prezzo) 
values (1, 'Piccola', 144.16),
(2, 'Piccola', 35.61),
(3, 'Piccola', 90.35),
(4, 'Piccola', 20.68),
(5, 'Piccola', 13.62),
(6, 'Piccola', 97.62),
(7, 'Piccola', 130.45),
(8, 'Piccola', 143.35),
(9, 'Piccola', 29.42),
(10, 'Piccola', 114.23),
(11, 'Piccola', 111.33),
(12, 'Piccola', 99.49),
(13, 'Piccola', 145.07),
(14, 'Piccola', 110.45),
(15, 'Piccola', 37.68),
(1, 'Media', 156.01),
(2, 'Media', 278.04),
(3, 'Media', 84.96),
(4, 'Media', 200.56),
(5, 'Media', 113.2),
(6, 'Media', 148.01),
(7, 'Media', 59.55),
(8, 'Media', 252.18),
(9, 'Media', 97.62),
(10, 'Media', 73.78),
(11, 'Media', 258.15),
(12, 'Media', 108.01),
(13, 'Media', 192.81),
(14, 'Media', 242.32),
(15, 'Media', 111.0),
(1, 'Grande', 441.07),
(2, 'Grande', 442.26),
(3, 'Grande', 386.04),
(4, 'Grande', 182.72),
(5, 'Grande', 161.16),
(6, 'Grande', 257.23),
(7, 'Grande', 387.95),
(8, 'Grande', 139.48),
(9, 'Grande', 120.88),
(10, 'Grande', 142.86),
(11, 'Grande', 410.36),
(12, 'Grande', 340.56),
(13, 'Grande', 298.81),
(14, 'Grande', 374.39),
(15, 'Grande', 225.24);



insert into Somministrazione (ID, Elemento, CatalogoPiante, MeseInizio, MeseFine, Dose) 
values (1, 'Azoto', 1, null, null, 85.18),
(2, 'Potassio', 2, null, null, 20.73),
(3, 'Fosforo', 3, null, null, 75.89),
(4, 'Calcio', 4, null, null, 82.41),
(5, 'Ferro', 5, 10, 12, 82.14),
(6, 'Magnesio', 6, null, null, 38.18),
(7, 'Zolfo', 7, null, null, 75.99),
(8, 'Rame', 8, null, null, 19.49),
(9, 'Cloro', 9, null, null, 27.57),
(10, 'Boro', 10, null, null, 43.48),
(11, 'Zinco', 11, 1, 2, 67.06),
(12, 'Manganese', 12, null, null, 79.03),
(13, 'Molibdeno', 13, null, null, 14.21),
(14, 'Chelato di Ferro', 14, null, null, 17.58),
(15, 'Nitrato di Potassio', 15, null, null, 53.92),
(16, 'Azoto', 3, null, null, 29.15),
(17, 'Potassio', 4, null, null, 61.0),
(18, 'Fosforo', 5, null, null, 76.01),
(19, 'Calcio', 6, null, null, 12.56),
(20, 'Ferro', 7, null, null, 98.56),
(21, 'Magnesio', 8, null, null, 25.03),
(22, 'Zolfo', 9, null, null, 9.12),
(23, 'Rame', 10, null, null, 45.54),
(24, 'Cloro', 11, null, null, 55.76),
(25, 'Boro', 12, null, null, 81.21),
(26, 'Zinco', 13, null, null, 36.66),
(27, 'Manganese', 14, null, null, 80.36),
(28, 'Molibdeno', 15, null, null, 75.54);



insert into Stoccaggio (Risorse, Sede, Quantita) 
values (1, 1, 37),
(2, 2, 28),
(3, 3, 29),
(4, 4, 41),
(5, 5, 90),
(6, 6, 62),
(7, 7, 20),
(8, 8, 21),
(9, 9, 8),
(10, 10, 15),
(22, 1, 47),
(23, 1, 30),
(24, 2, 72),
(25, 3, 35),
(26, 4, 68),
(27, 5, 32),
(1, 6, 9),
(1, 7, 95),
(2, 8, 74),
(3, 9, 23),
(4, 10, 82),
(17, 1, 48),
(18, 2, 4),
(19, 3, 81),
(20, 4, 2),
(21, 5, 35),
(22, 6, 26),
(23, 7, 69),
(24, 8, 93),
(25, 9, 49),
(26, 10, 29);


insert into Post (ID, AccountCliente, Testo) 
values (1, 1, 'nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam'),
(2, 2, 'praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat'),
(3, 3, 'habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida'),
(4, 4, 'potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus'),
(5, 5, 'fusce lacus purus aliquet at feugiat non pretium quis lectus'),
(6, 6, 'nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in'),
(7, 7, 'praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante'),
(8, 8, 'elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum'),
(9, 9, 'justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus'),
(10, 10, 'erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non');



-- hack per aggiornamento timestamp
SET @pivot_ts = '2016-01-15 22:15:45';
SET @max_span = 9568000;
SET @bias = SIGN(-0.5 + RAND());

UPDATE Post
SET TimestampPost = 
	(
	SELECT FROM_UNIXTIME(
		UNIX_TIMESTAMP(@pivot_ts) + ( @bias * (FLOOR(RAND()*@max_span)) )
		)
	)
WHERE AccountCliente < 10000; -- per aggirare safe update mode


insert into PostArchivio (ID, AccountCliente, Testo) 
values (1, 1, 'metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci'),
(2, 2, 'id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque'),
(3, 3, 'sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum'),
(4, 4, 'in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo'),
(5, 5, 'nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue'),
(6, 6, 'commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit'),
(7, 7, 'ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at'),
(8, 8, 'orci mauris lacinia sapien quis libero nullam sit amet turpis elementum'),
(9, 9, 'viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere'),
(10, 10, 'non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros');

-- hack per aggiornamento timestamp
UPDATE PostArchivio
SET TimestampPost = 
	(
	SELECT FROM_UNIXTIME(
		UNIX_TIMESTAMP(@pivot_ts) + ( @bias * (FLOOR(RAND()*@max_span)) )
		)
	)
WHERE AccountCliente < 10000; -- per aggirare safe update mode



insert into Prospetto (ID, AccountCliente, Nome, Descrizione) 
values (1, 1, 'Flowdesk', 'convallis tortor risus dapibus augue vel accumsan tellus nisi eu'),
(2, 2, 'Wrapsafe', 'nulla tellus in sagittis dui vel nisl'),
(3, 3, 'Sub-Ex', 'at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea'),
(4, 4, 'Solarbreeze', 'tortor quis turpis sed ante vivamus tortor duis mattis egestas metus'),
(5, 5, 'Quo Lux', 'elementum in hac habitasse platea dictumst morbi'),
(6, 6, 'Lotstring', 'sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor'),
(7, 7, 'Latlux', 'id ligula suspendisse ornare consequat lectus'),
(8, 8, 'Sonair', 'quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis'),
(9, 9, 'Mat Lam Tam', 'neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit'),
(10, 10, 'Y-Solowarm', 'ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit');



insert into Spazio (ID, Prospetto) 
values (1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);



insert into Settore (ID, Spazio, Orientamento, OreSole, LuceDiretta, PienaTerra) 
values (1, 1, 'Ovest', 5, false, true),
(2, 2, 'Nord', 3, true, true),
(3, 3, 'Est', 14, true, true),
(4, 4, 'Nord-Ovest', 6, true, true),
(5, 5, 'Est', 4, true, false),
(6, 6, 'Sud-Est', 1, true, true),
(7, 7, 'Nord-Ovest', 14, false, true),
(8, 8, 'Nord-Ovest', 5, false, true),
(9, 9, 'Sud-Ovest', 7, false, true),
(10, 10, 'Sud-Ovest', 8, true, true),
(11, 1, 'Ovest', 7, true, true),
(12, 2, 'Nord-Ovest', 3, false, false),
(13, 3, 'Nord-Est', 12, false, true),
(14, 4, 'Est', 5, true, false),
(15, 5, 'Nord-Est', 10, false, true),
(16, 6, 'Sud-Ovest', 10, true, false),
(17, 7, 'Nord', 5, true, true),
(18, 8, 'Nord-Ovest', 2, true, false),
(19, 9, 'Nord-Est', 12, true, false),
(20, 10, 'Sud-Ovest', 8, true, true);


insert into Vaso (ID, Settore, X, Y, Raggio, Materiale) 
values (1, 1, 798.29, 361.49, 35.81, 'Ceramica'),
(2, 2, 1687.32, 989.85, 108.18, 'Plastica'),
(3, 3, 1771.83, 115.21, 181.34, 'Ceramica'),
(4, 4, 891.95, 863.05, 155.06, 'Creta'),
(5, 5, 695.82, 474.71, 148.52, 'Vetro'),
(6, 6, 540.4, 890.11, 185.38, 'Vetro'),
(7, 7, 1915.24, 94.56, 145.44, 'Plastica'),
(8, 8, 720.11, 695.61, 140.23, 'Mattoni'),
(9, 2, 1471.73, 51.62, 91.94, 'Mattoni'),
(10, 1, 991.81, 309.24, 94.24, 'Mattoni');



insert into VerticeSettore (ID, Settore, X, Y) 
values (1, 1, 146.22, 833.11),
(1, 2, 1887.82, 970.31),
(1, 3, 1398.84, 611.46),
(1, 4, 132.18, 296.1),
(1, 5, 449.02, 273.55),
(1, 6, 1488.84, 1039.28),
(1, 7, 239.11, 442.6),
(1, 8, 461.51, 83.33),
(1, 9, 1708.1, 1052.37),
(1, 10, 334.48, 105.1),
(1, 11, 818.32, 475.71),
(1, 12, 1286.66, 348.9),
(1, 13, 1800.81, 927.39),
(1, 14, 1326.51, 869.78),
(1, 15, 179.77, 134.62),
(1, 16, 1816.33, 725.52),
(1, 17, 1013.48, 7.29),
(1, 18, 1360.41, 316.4),
(1, 19, 10.08, 234.48),
(1, 20, 981.74, 999.24),
(2, 1, 1673.75, 546.5),
(2, 2, 762.74, 335.92),
(2, 3, 1631.26, 730.76),
(2, 4, 1032.74, 100.74),
(2, 5, 489.27, 334.45),
(2, 6, 828.9, 941.25),
(2, 7, 869.68, 900.35),
(2, 8, 456.38, 332.39),
(2, 9, 977.05, 846.25),
(2, 10, 1424.97, 837.32),
(2, 11, 865.61, 778.17),
(2, 12, 587.55, 926.69),
(2, 13, 1113.42, 1067.13),
(2, 14, 1029.04, 192.58),
(2, 15, 1489.6, 397.16),
(2, 16, 896.68, 890.5),
(2, 17, 190.34, 1041.19),
(2, 18, 708.84, 506.63),
(2, 19, 677.88, 1053.57),
(2, 20, 1665.62, 878.21),
(3, 1, 21.33, 618.06),
(3, 2, 559.13, 20.08),
(3, 3, 759.12, 1022.53),
(3, 4, 1391.63, 389.0),
(3, 5, 220.92, 822.75),
(3, 6, 1065.77, 349.9),
(3, 7, 1189.6, 1028.09),
(3, 8, 1325.68, 591.45),
(3, 9, 1639.78, 24.23),
(3, 10, 1893.56, 1027.42),
(3, 11, 1099.9, 830.8),
(3, 12, 1080.26, 367.42),
(3, 13, 721.6, 906.59),
(3, 14, 1610.06, 537.59),
(3, 15, 1340.19, 881.38),
(3, 16, 273.84, 624.15),
(3, 17, 1141.83, 358.62),
(3, 18, 716.37, 829.18),
(3, 19, 601.01, 712.17),
(3, 20, 438.4, 72.04);



insert into VerticeSpazio (ID, Spazio, X, Y) 
values (1, 1, 1422.43, 325.79),
(1, 2, 1072.29, 522.31),
(1, 3, 368.06, 592.18),
(1, 4, 124.62, 883.52),
(1, 5, 1187.06, 841.84),
(1, 6, 45.95, 174.57),
(1, 7, 1495.64, 637.29),
(1, 8, 1585.98, 456.41),
(1, 9, 786.33, 991.22),
(1, 10, 1744.6, 405.82),
(2, 1, 1102.41, 780.83),
(2, 2, 1195.17, 638.55),
(2, 3, 1901.67, 309.62),
(2, 4, 789.55, 923.3),
(2, 5, 160.64, 442.42),
(2, 6, 477.13, 673.23),
(2, 7, 607.83, 232.94),
(2, 8, 628.64, 560.18),
(2, 9, 1724.35, 767.04),
(2, 10, 993.53, 728.43),
(3, 1, 1734.94, 4.62),
(3, 2, 710.72, 650.33),
(3, 3, 1541.99, 235.76),
(3, 4, 1310.66, 265.57),
(3, 5, 1190.25, 502.09),
(3, 6, 1004.77, 882.01),
(3, 7, 1520.0, 249.46),
(3, 8, 928.86, 1068.65),
(3, 9, 1129.33, 762.5),
(3, 10, 1141.52, 377.56);



insert into AccoglieCatalogo (ID, CatalogoPiante, X, Y, Raggio, Settore) 
values (1, 1, 613.5, 102.7, 95.1, 11),
(2, 2, 1630.61, 48.89, 102.15, 12),
(3, 3, 955.77, 14.82, 190.23, 13),
(4, 4, 1157.17, 166.53, 23.45, 14),
(5, 5, 1265.13, 857.36, 150.53, 15),
(6, 6, 82.01, 925.55, 65.92, 16),
(7, 7, 761.96, 317.37, 33.88, 17),
(8, 8, 1517.2, 215.71, 108.31, 18),
(9, 9, 1011.62, 579.66, 65.7, 19),
(10, 10, 519.32, 334.35, 90.55, 20);


insert into OspitaCatalogo (CatalogoPiante, Vaso) 
values (1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


insert into Risposta (ID, Post, AccountCliente, Testo) 
values (1, 1, 2, 'dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor'),
(1, 2, 4, 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean'),
(1, 3, 6, 'praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi'),
(1, 4, 8, 'lorem ipsum dolor sit amet consectetuer adipiscing elit proin risus'),
(1, 5, 10, 'ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit'),
(1, 6, 2, 'in felis eu sapien cursus vestibulum proin eu mi nulla ac enim'),
(1, 7, 4, 'interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam'),
(1, 8, 6, 'suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce'),
(1, 9, 8, 'platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id'),
(1, 10, 10, 'in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus'),
(2, 1, 2, 'pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis'),
(2, 2, 4, 'interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien'),
(2, 3, 6, 'vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu'),
(2, 4, 8, 'ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in'),
(2, 5, 10, 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor'),
(2, 6, 1, 'consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae'),
(2, 7, 3, 'at velit eu est congue elementum in hac habitasse platea'),
(2, 8, 5, 'integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero'),
(2, 9, 4, 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla'),
(2, 10, 8, 'sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis');


-- hack per aggiornamento timestamp
SET @pivot_ts = '2016-01-15 22:15:45';
SET @max_span = 9568000;
SET @bias = SIGN(-0.5 + RAND());

UPDATE Risposta
SET TimestampRisposta = 
	(
	SELECT FROM_UNIXTIME(
		UNIX_TIMESTAMP(@pivot_ts) + ( @bias * (FLOOR(RAND()*@max_span)) )
		)
	)
WHERE AccountCliente < 10000; -- per aggirare safe update mode


insert into RispostaArchivio (ID, PostArchivio, AccountCliente, Testo) 
values (1, 1, 1, 'arcu sed augue aliquam erat volutpat in congue etiam justo'),
(1, 2, 3, 'vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis'),
(1, 3, 5, 'consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices'),
(1, 4, 7, 'primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut'),
(1, 5, 9, 'posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem'),
(1, 6, 1, 'scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc'),
(1, 7, 3, 'a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue'),
(1, 8, 5, 'odio donec vitae nisi nam ultrices libero non mattis pulvinar'),
(1, 9, 7, 'eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci'),
(1, 10, 9, 'libero rutrum ac lobortis vel dapibus at diam nam tristique'),
(2, 1, 2, 'odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel'),
(2, 2, 4, 'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi'),
(2, 3, 6, 'lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada'),
(2, 4, 8, 'amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum'),
(2, 5, 10, 'in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst'),
(2, 6, 2, 'eget nunc donec quis orci eget orci vehicula condimentum curabitur in'),
(2, 7, 4, 'vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum'),
(2, 8, 6, 'semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor'),
(2, 9, 8, 'interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at'),
(2, 10, 10, 'cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus');


-- hack per aggiornamento timestamp
SET @pivot_ts = '2016-01-15 22:15:45';
SET @max_span = 9568000;
SET @bias = SIGN(-0.5 + RAND());

UPDATE RispostaArchivio
SET TimestampRisposta = 
	(
	SELECT FROM_UNIXTIME(
		UNIX_TIMESTAMP(@pivot_ts) + ( @bias * (FLOOR(RAND()*@max_span)) )
		)
	)
WHERE AccountCliente < 10000; -- per aggirare safe update mode



insert into LinkPost (ID, Post, URL) 
values (1, 1, 'http://php.net'),
(2, 5, 'http://soundcloud.com'),
(3, 7, 'http://tinypic.com'),
(4, 9, 'https://phoca.cz');



insert into LinkRisposta (ID, Post, Risposta, URL) 
values (1, 1, 1, 'https://addthis.com'),
(2, 2, 1, 'https://google.cn'),
(3, 3, 1, 'https://mozilla.org'),
(4, 4, 1, 'http://wikipedia.org'),
(5, 5, 1, 'http://dagondesign.com'),
(6, 6, 2, 'http://va.gov'),
(7, 7, 2, 'http://intel.com');



insert into LinkPostArchivio (ID, PostArchivio, URL) 
values 
(1, 1, 'https://hibu.com'),
(2, 2, 'http://reuters.com'),
(3, 3, 'http://constantcontact.com'),
(4, 4, 'http://google.com'),
(5, 3, 'http://yahoo.com'),
(6, 1, 'http://facebook.com'),
(7, 1, 'http://imgur.com'),
(8, 1, 'http://xkcd.com'),
(9, 4, 'http://smbc.com'),
(10, 3, 'http://reddit.com');



insert into LinkRispArchivio (ID, PostArchivio, RispostaArchivio, URL) 
values 
(1, 1, 1, 'http://w3.org'),
(2, 2, 2, 'https://blinklist.com'),
(3, 3, 1, 'http://gnu.org'),
(4, 4, 1, 'https://lulu.com'),
(5, 5, 1, 'http://kickstarter.com'),
(6, 6, 2, 'https://xrea.com'),
(7, 7, 2, 'http://amazon.co.jp');


insert into Preferenze (AccountCliente, CatalogoPiante) 
values (1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 1),
(4, 2),
(5, 7),
(5, 10),
(6, 8),
(6, 3),
(7, 4),
(7, 8),
(8, 2),
(8, 3),
(9, 3),
(9, 5),
(10, 10),
(10, 1);



insert into Valuta (AccountCliente, Post, Risposta, Voto) 
values (1, 1, 1, 1),
(2, 2, 1, 5),
(3, 3, 1, 4),
(1, 4, 2, 3),
(2, 5, 2, 5),
(3, 6, 1, 3),
(7, 7, 1, 5),
(8, 8, 1, 2),
(7, 9, 2, 3),
(2, 10, 2, 1);



insert into ValutaArchivio (AccountCliente, PostArchivio, RispostaArchivio, Voto) 
values (6, 1, 2, 4),
(4, 2, 2, 1),
(8, 3, 1, 1),
(4, 4, 2, 5),
(4, 5, 1, 5),
(6, 6, 1, 3),
(5, 7, 1, 4),
(3, 8, 2, 4),
(5, 9, 2, 4),
(3, 10, 2, 4);


insert into Ordine (AccountCliente, ImportoTotale, Stato, TimestampEvasione)
values (1, 0, 'In Processazione',NULL),
(2, 0, 'In Processazione',NULL),
(3, 180, 'In Processazione',NULL),
(1, 220, 'In Processazione',NULL);

INSERT INTO Trattamento (ID, Pianta, Esito) VALUES 
(1, 15, 'Negativo'),
(2, 30, 'Negativo'),
(3, 17, 'Positivo'),
(4, 58, 'Positivo'),
(5, 44, 'Positivo'),
(6, 42, 'Positivo'),
(7, 7, 'Positivo'),
(8, 8, 'Positivo'),
(9, 18, 'Positivo'),
(10, 26, 'Negativo'),
(11, 52, 'Positivo'),
(12, 55, 'Negativo'),
(13, 18, 'Positivo'),
(14, 27, 'Positivo'),
(15, 24, 'Positivo'),
(16, 56, 'Negativo'),
(17, 42, 'Negativo'),
(18, 58, 'Negativo'),
(19, 11, 'Positivo'),
(20, 20, 'Positivo'),
(21, 1, 'Positivo'),
(22, 9, 'Negativo'),
(23, 46, 'Positivo'),
(24, 55, 'Negativo'),
(25, 42, 'Negativo'),
(26, 2, 'Positivo'),
(27, 24, 'Positivo'),
(28, 13, 'Positivo'),
(29, 26, 'Positivo'),
(30, 21, 'Negativo'),
(31, 29, 'Positivo'),
(32, 6, 'Negativo'),
(33, 11, 'Negativo'),
(34, 43, 'Negativo'),
(35, 10, 'Positivo'),
(36, 23, 'Positivo'),
(37, 7, 'Positivo'),
(38, 1, 'Positivo'),
(39, 3, 'Negativo'),
(40, 43, 'Positivo'),
(41, 23, 'Negativo'),
(42, 13, 'Negativo'),
(43, 38, 'Positivo'),
(44, 39, 'Negativo'),
(45, 38, 'Positivo'),
(46, 33, 'Positivo'),
(47, 36, 'Negativo'),
(48, 55, 'Positivo'),
(49, 51, 'Negativo'),
(50, 48, 'Positivo');

-- hack per aggiornamento timestamp
SET @pivot_ts = '2016-01-15 22:15:45';
SET @max_span = 9568000;
SET @bias = SIGN(-0.5 + RAND());

UPDATE Trattamento
SET TimestampTrattamento = 
	(
	SELECT FROM_UNIXTIME(
		UNIX_TIMESTAMP(@pivot_ts) + ( @bias * (FLOOR(RAND()*@max_span)) )
		)
	)
WHERE ID < 10000; -- per aggirare safe update mode

insert into ReportDiagnostica
values(),();

insert into Diagnosi (Pianta) 
values 
(27),
(50),
(13),
(56),
(39);

INSERT INTO Utilizzo(Trattamento,Farmaco) VALUES
(1, 9),
(2, 4),
(3, 6),
(4, 3),
(5,10),
(6, 8),
(7, 7),
(8, 1),
(9, 5),
(10, 3),
(11, 1),
(12, 2),
(13, 4),
(14, 4),
(15, 8),
(16, 2),
(17, 1),
(18, 9),
(19, 4),
(20, 3),
(21, 5),
(22, 2),
(23, 7),
(24, 4),
(25, 9),
(26, 6),
(27, 3),
(28, 3),
(29, 1),
(30, 2),
(31, 8),
(32, 7),
(33, 6),
(34, 8),
(35, 9),
(36, 8),
(37, 5),
(38, 6),
(39, 6),
(40, 9),
(41, 3),
(42, 10),
(43, 8),
(44, 5),
(45, 2),
(46, 9),
(47, 9),
(48, 5),
(49, 8),
(50, 10);

insert into PianteVendute (Codice, CatalogoPiante, Serra, Sesso, DimAttuale) 
values (61, 14, 7, 'F', 'Piccola'),
(62, 10, 9, 'F', 'Grande'),
(63, 14, 1, 'F', 'Grande'),
(64, 7, 4, 'F', 'Media'),
(65, 11, 4, 'M', 'Media'),
(66, 9, 6, 'F', 'Piccola'),
(67, 5, 12, 'M', 'Media'),
(68, 7, 3, 'M', 'Media'),
(69, 14, 2, 'M', 'Grande'),
(70, 5, 2, 'M', 'Piccola'),
(71, 9, 3, 'F', 'Media'),
(72, 3, 13, 'M', 'Media'),
(73, 14, 13, 'M', 'Media'),
(74, 10, 3, 'F', 'Piccola'),
(75, 2, 4, 'F', 'Piccola'),
(76, 12, 15, 'F', 'Grande'),
(77, 5, 1, 'F', 'Piccola'),
(78, 11, 9, 'F', 'Media'),
(79, 13, 10, 'M', 'Piccola'),
(80, 14, 8, 'F', 'Piccola');


insert into SchedaPianta (AccountCliente, ManAuto, CatalogoPiante, DataAcquisto, DimAcquisto, RiceveNotifiche) 
values (7, 0, 6, current_date(), 'Media', 0),
(6, 0, 4, current_date(), 'Piccola', 0),
(2, 0, 12, current_date(), 'Media', 0),
(9, 0, 15, current_date(), 'Media', 0),
(1, 0, 11, current_date(), 'Grande', 0),
(9, 0, 13, current_date(), 'Media', 0),
(1, 0, 14, current_date(), 'Media', 0),
(8, 0, 11, current_date(), 'Piccola', 0),
(2, 0, 15, current_date(), 'Piccola', 0),
(2, 0, 5, current_date(), 'Piccola', 0),
(7, 0, 9, current_date(), 'Piccola', 0),
(6, 0, 5, current_date(), 'Piccola', 0),
(2, 0, 10, current_date(), 'Grande', 0),
(3, 0, 8, current_date(), 'Piccola', 0),
(6, 0, 2, current_date(), 'Piccola', 0),
(7, 0, 1, current_date(), 'Grande', 0),
(7, 0, 13, current_date(), 'Grande', 0),
(5, 0, 6, current_date(), 'Media', 0),
(10, 0, 11, current_date(), 'Media', 0),
(7, 0, 2, current_date(), 'Media', 0);

INSERT INTO Ipotesi(Diagnosi,Patologia,Certezza) VALUES 
(1, 'Alternaria alternata f.sp. fragariae', 95.43),
(2, 'Alternaria alternata f.sp. cucurbitae', 85.73),
(1, 'Aphelenchoides coffeae', 28.95),
(3, 'Alternaria sonchi', 72.31),
(1, 'Acremonium strictum', 57.77),
(2, 'Aphelenchoides coffeae', 45.99),
(5, 'Aphelenchoides coffeae', 28.78),
(3, 'Legno nero', 93.44),
(4, 'Legno nero', 97.17),
(4, 'Aphelenchoides coffeae', 11.84),
(3, 'Alternaria alternata f.sp. fragariae', 8.45),
(3, 'Aphelenchoides coffeae', 77.62),
(4, 'Alternaria alternata f.sp. cucurbitae', 70.76),
(2, 'Alternaria sonchi', 2.62),
(3, 'Alternaria alternata f.sp. cucurbitae', 29.34),
(1, 'Alternaria alternata f.sp. fragariae', 29.4),
(5, 'Alternaria alternata f.sp. cucurbitae', 72.82),
(3, 'Alternaria sonchi', 36.68),
(3, 'Acremonium strictum', 18.51),
(5, 'Alternaria sonchi',99.99);


insert into SchedaIntervento (Ordine, SchedaPianta, CatalogoIntervento, Luogo, DataesecuzioneSopralluogo, Prezzo, Stato, TipoPeriodicita) 
values (2, 20, 7, 'Cagliari', current_date(), 290.01, 'Eseguito', 'Programmata'),
(3, 12, 8, 'Roma', current_date(), 197.66, 'Eseguito', 'Programmata'),
(3, 20, 9, 'Roma', current_date(), 283.4, 'Eseguito', 'Automatica'),
(1, 8, 1, 'Roma', current_date(), 97.13, 'Eseguito', 'Programmata'),
(1, 3, 1, 'Napoli', current_date(), 276.81, 'Eseguito', 'Autonoma'),
(3, 19, 5, 'Roma', current_date(), 240.65, 'Eseguito', 'Programmata'),
(3, 15, 9, 'Cagliari', current_date(), 267.87, 'Eseguito', 'Programmata'),
(2, 7, 7, 'Torino', current_date(), 180.3, 'Eseguito', 'Automatica'),
(2, 19, 4, 'Milano', current_date(), 80.08, 'Eseguito', 'Richiesta'),
(3, 6, 7, 'Cagliari', current_date(), 130.65, 'Eseguito', 'Richiesta'),
(2, 9, 1, 'Roma', current_date(), 16.36, 'Eseguito', 'Automatica'),
(4, 19, 5, 'Napoli', current_date(), 286.55, 'Eseguito', 'Automatica'),
(4, 3, 10, 'Torino', current_date(), 282.15, 'Eseguito', 'Richiesta'),
(1, 10, 9, 'Napoli', current_date(), 169.93, 'Eseguito', 'Richiesta'),
(4, 7, 10, 'Torino', current_date(), 206.08, 'Eseguito', 'Programmata'),
(4, 19, 7, 'Cagliari', current_date(), 20.55, 'Eseguito', 'Automatica'),
(2, 7, 3, 'Napoli', current_date(), 5.36, 'Eseguito', 'Autonoma'),
(1, 16, 5, 'Torino', current_date(), 43.16, 'Eseguito', 'Programmata'),
(3, 15, 4, 'Cagliari', current_date(), 39.45, 'Eseguito', 'Automatica'),
(3, 20, 2, 'Torino', current_date(), 239.51, 'Eseguito', 'Automatica');

INSERT INTO Accoglie(SchedaPianta,Settore,X,Y,Raggio) VALUES
(5,1,100,100,50),
(7,11,50,20,5),
(3,2, 50, 80, 10),
(9,12, 90, 90, 10),
(10, 2, 300, 300, 40),
(13, 12, 500, 300, 10),
(14, 3, 400, 200, 90),
(18, 5, 100, 100, 20),
(11,7, 300, 200, 10),
(16,17, 300, 200, 10),
(17,7, 10, 10, 3),
(1,17, 500, 10, 4),
(20,17, 40, 40, 4);


INSERT INTO Riscontro VALUES
(1,1),
(1,5),
(2,3),
(3,1),
(4,2),
(5,5),
(6,2),
(7,2),
(8,4),
(10,2),
(12,1),
(9,3),
(8,3);

INSERT INTO Causa VALUES
(1,1),
(1,2),
(1,8),
(2,2),
(2,3),
(2,5),
(3,4),
(3,3),
(4,1),
(4,8),
(4,9),
(5,3),
(5,4),
(6,2),
(7,9),
(7,7),
(8,7),
(9,9),
(10,10),
(11,10),
(12,10);

INSERT INTO Richiede VALUES
(1,28,5),
(2,14,1),
(2,10,2),
(3,1,1),
(3,7,2),
(5,5,1),
(6,1,1),
(8,2,3),
(9,10,2),
(11,11,10),
(15,2,3);

INSERT INTO Ospita VALUES
(12,6),
(8,8);

INSERT INTO Inclusione VALUES
(1,1),(2,1),(3,1),(4,2),(5,2);

INSERT INTO DataManutenzione VALUES
(1,current_date(),'Eseguita'),
(1,current_date() - INTERVAL 3 DAY,'Eseguita'),
(2,current_date() - INTERVAL 1 MONTH,'Eseguita'),
(2,current_date() - INTERVAL 2 MONTH,'Eseguita'),
(4,current_date(),'Eseguita'),
(4,current_date() - INTERVAL 3 WEEK,'Eseguita'),
(6,current_date() - INTERVAL 6 MONTH,'Eseguita'),
(6,current_date() - INTERVAL 2 DAY,'Eseguita'),
(15,current_date() - INTERVAL 1 DAY,'Eseguita'),
(15,current_date(),'Eseguita'),
(18,current_date() - INTERVAL 6 WEEK,'Eseguita'),
(18,current_date() - INTERVAL 3 MONTH,'Eseguita'),
(3,current_date() - INTERVAL 3 MONTH,'Eseguita'),
(5,current_date() - INTERVAL 2 MONTH,'Eseguita'),
(8,current_date() - INTERVAL 1 MONTH,'Eseguita'),
(9,current_date() - INTERVAL 2 MONTH,'Eseguita'),
(10,current_date() - INTERVAL 4 MONTH,'Eseguita'),
(11,current_date() - INTERVAL 3 MONTH,'Eseguita'),
(12,current_date() - INTERVAL 1 MONTH,'Eseguita'),
(13,current_date() - INTERVAL 9 MONTH,'Eseguita'),
(14,current_date() - INTERVAL 2 MONTH,'Eseguita'),
(16,current_date() - INTERVAL 7 MONTH,'Eseguita'),
(17,current_date() - INTERVAL 9 MONTH,'Eseguita'),
(19,current_date() - INTERVAL 7 MONTH,'Eseguita'),
(20,current_date() - INTERVAL 1 MONTH,'Eseguita'),
(20,current_date() - INTERVAL 12 MONTH,'Eseguita');

INSERT INTO Articolo VALUES 
(1,1),
(2,1),
(3,1),
(4,2),
(5,2),
(7,3),
(8,3),
(10,4),
(11,4),
(12,4);

/* IMPLEMENTAZIONE TRIGGERS, EVENT, STORED PROCEDURES, ANALYTICS */

-- TRIGGER: EVASIONE ORDINE E CREAZIONE SCHEDA PIANTA
USE ACME;

DROP TRIGGER IF EXISTS OrdineEvaso;
DROP PROCEDURE IF EXISTS SetSchedaPianta;

DELIMITER $$

CREATE PROCEDURE SetSchedaPianta (IN _IDOrdine INT)

BEGIN
	
    DECLARE Finito INT DEFAULT 0;
    DECLARE CodPianta INT;
    DECLARE scorriArticoli CURSOR FOR
		SELECT Pianta
        FROM Articolo
        WHERE Ordine = _IDOrdine;
        
        
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET Finito = 1;
        
	OPEN scorriArticoli;
    
    preleva: LOOP
			
            FETCH scorriArticoli INTO CodPianta;
			IF Finito = 1 THEN
				LEAVE preleva;
			END IF;
            
            SET @AccountCliente = (SELECT AccountCliente FROM Ordine WHERE ID = _IDOrdine);
            SET @CatalogoPiante = (SELECT CatalogoPiante FROM Pianta WHERE Codice = CodPianta);
            SET @DataAcquisto = (SELECT TimestampEvasione FROM Ordine WHERE ID = _IDOrdine);
            SET @DimAcquisto = (SELECT DimAttuale FROM Pianta WHERE Codice = CodPianta);
            
            INSERT INTO SchedaPianta (AccountCliente, CatalogoPiante, ManAuto, DataAcquisto, DimAcquisto, RiceveNotifiche)
				VALUES (@AccountCliente, @CatalogoPiante, FALSE, @DataAcquisto, @DimAcquisto, FALSE);
                
			UPDATE Contenitore
            SET Pianta = NULL
            WHERE Pianta = CodPianta;
            
			DELETE FROM Pianta
            WHERE Codice = CodPianta;
            
	END LOOP preleva;
    
    CLOSE scorriArticoli;

END $$

CREATE TRIGGER OrdineEvaso AFTER UPDATE ON Ordine 
FOR EACH ROW
BEGIN 

	IF NEW.Stato = 'Evaso' THEN
		Call SetSchedaPianta (NEW.ID);
	END IF;

END $$

DELIMITER ;

-- TRIGGER: Archiviazione piante vendute su ordini evasi

USE ACME;
DROP TRIGGER IF EXISTS ArchiviazionePianteVendute;

DELIMITER $$
CREATE TRIGGER ArchiviazionePianteVendute
BEFORE DELETE ON Pianta
FOR EACH ROW
BEGIN
	INSERT INTO PianteVendute(Codice,CatalogoPiante,Serra,Sesso,DimAttuale) 
		VALUES(OLD.Codice,OLD.CatalogoPiante,OLD.Serra,OLD.Sesso,OLD.DimAttuale);
    INSERT INTO DiagnosiPianteVendute (SELECT * FROM Diagnosi WHERE Pianta = OLD.Codice);
END$$
DELIMITER ;

-- EVENT: ARCHIVIAZIONE DATI CONTENITORE PER STUDIO PATOLOGIE

DROP TABLE IF EXISTS StoricoContenitore;
CREATE TABLE StoricoContenitore 
	(
	CodiceContenitore INT,
    PiantaContenuta INT,
    TimestampContenitore TIMESTAMP,
    Illuminazione ENUM('Bassa','Media','Alta'),
    Temperatura	INT,
    Umidita FLOAT (4,2),
    Irrigazione ENUM('Bassa','Media','Alta'),
    Idratazione FLOAT(4,2)
    );

DROP EVENT IF EXISTS BackupDatiContenitore;
DELIMITER $$
CREATE EVENT BackupDatiContenitore
ON SCHEDULE EVERY 1 DAY DO
    BEGIN
		INSERT INTO StoricoContenitore(CodiceContenitore,Illuminazione,Temperatura,Umidita,Irrigazione,Idratazione)
        (
			SELECT C.Codice,C.Pianta,S.Illuminazione,S.Temperatura,S.Umidita,R.Irrigazione,C.Idratazione
			FROM Contenitore C
				INNER JOIN Ripiano R ON C.Ripiano = R.Codice
				INNER JOIN Sezione S ON R.Sezione = S.Codice
                INNER JOIN Pianta P ON C.Pianta = P.Codice
			WHERE C.Pianta IS NOT NULL
		);
	END$$
DELIMITER ;

-- STORED PROCEDURE: CALCOLO AREA DI UN SETTORE

DROP PROCEDURE IF EXISTS CalcoloAreaSettore;

DELIMITER $$
CREATE PROCEDURE CalcoloAreaSettore (IN _codiceSettore INT, INOUT _area INT)

BEGIN
    DECLARE END_OF_RESULTSET BOOL DEFAULT FALSE;
	DROP TABLE IF EXISTS Punti;
	CREATE TABLE Punti AS (SELECT * FROM VerticeSettore WHERE Settore = _codiceSettore);
	/* l'algoritmo necessita di un numero dispari di punti. Se sono pari, si fa l'append del primo punto */
	SET @NumeroPunti = (SELECT COUNT(*) FROM Punti);
    IF @NumeroPunti % 2 = 0 THEN
		INSERT INTO Punti(X,Y)(SELECT X,Y FROM Punti WHERE ID=1);
        SET @NumeroPunti = @NumeroPunti + 1;
	END IF;
	
    SET @Area = 0;
    SET @i = 0;
    WHILE @i < @NumeroPunti DO
		SET @x_1 = (SELECT X FROM Punti WHERE ID = @i + 1);
        SET @y_2 = (SELECT Y FROM Punti WHERE ID = @i + 2);
        SET @y   = (SELECT Y FROM Punti WHERE ID = @i);
        SET @y_1 = (SELECT Y FROM Punti WHERE ID = @i + 1);
        SET @x   = (SELECT X FROM Punti WHERE ID = @i);
        SET @x_2 = (SELECT X FROM Punti WHERE ID = @i + 2);
		SET @Area = @Area + (@x_1)*(@y_2 - @y) + @y_1 * (@x - @x_2);
        SET @i = @i + 1;
    END WHILE;
    SET @Area = @Area / 2;
	SET _area = @Area;
END $$
DELIMITER ;

-- STORED PROCEDURE + TRIGGER: CONTROLLO POSIZIONAMENTO OGGETTI IN UN SETTORE

USE ACME;

DROP PROCEDURE IF EXISTS InserisciOggetto;

DELIMITER $$
CREATE PROCEDURE InserisciOggetto
					(
					IN _settore INT,
                    IN _X INT,
                    IN _Y INT,
                    IN _Raggio INT,
                    INOUT _response BOOL
                    )
BEGIN
	SET _response = TRUE;
    DROP TABLE IF EXISTS VerticiSettoreCorrente;
	CREATE TEMPORARY TABLE VerticiSettoreCorrente AS 
		(
		SELECT *
		FROM VerticeSettore
		WHERE Settore = _settore
		);
	SET @NumVertici = (SELECT MAX(ID) FROM VerticiSettoreCorrente);
    SET @i=1;
    WHILE @i < @NumVertici DO
		SET @x1 = (SELECT X FROM VerticiSettoreCorrente WHERE ID = @i);
        SET @x2	= (SELECT X FROM VerticiSettoreCorrente WHERE ID = @i+1);
        SET @y1 = (SELECT Y FROM VerticiSettoreCorrente WHERE ID = @i);
        SET @y2 = (SELECT Y FROM VerticiSettoreCorrente WHERE ID = @i+1);
		
        -- x_2 diverso da x_1
        IF(@x2 <> @x1) THEN
			SET @m = (@y2 - @y1) / (@x2 - @x1);
			SET @q = @y1 - (@m * @x1);
        
			SET @d = (abs(_Y - (@m * _X) + @q)) / (sqrt(1 + (@m)^2));
		ELSE 
			SET @d = abs(_X - @x1);
		END IF;
        IF @d < _Raggio THEN
			SET _response = FALSE;
		END IF;
	SET @i = @i + 1;
	END WHILE;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS InserisciVaso;
DELIMITER $$
CREATE TRIGGER InserisciVaso
BEFORE INSERT ON Vaso
FOR EACH ROW
	BEGIN
    SET @response = FALSE;
    CALL InserisciOggetto(NEW.Settore, NEW.X, NEW.Y, NEW.Raggio, @response);
    IF @response = FALSE THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'ERROR: OBJECT IS OUT OF BOUNDARY', MYSQL_ERRNO = 45000;
	END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS InserisciPianta;
DELIMITER $$
CREATE TRIGGER InserisciPianta
BEFORE INSERT ON Accoglie
FOR EACH ROW
	BEGIN
    SET @response = FALSE;
    CALL InserisciOggetto(NEW.Settore, NEW.X, NEW.Y, NEW.Raggio, @response);
    IF @response = FALSE THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'ERROR: OBJECT IS OUT OF BOUNDARY', MYSQL_ERRNO = 45000;
	END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS InserisciPiantaCatalogo;
DELIMITER $$
CREATE TRIGGER InserisciPiantaCatalogo
BEFORE INSERT ON AccoglieCatalogo
FOR EACH ROW
	BEGIN
    SET @response = FALSE;
    CALL InserisciOggetto(NEW.Settore, NEW.X, NEW.Y, NEW.Raggio, @response);
    IF @response = FALSE THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'ERROR: OBJECT IS OUT OF BOUNDARY', MYSQL_ERRNO = 45000;
	END IF;
END$$
DELIMITER ;

-- STORED PROCEDURE: STAMPA DELLE PATOLOGIE PIÙ COMUNI

USE ACME;

DROP PROCEDURE IF EXISTS PatologiePiuComuni;
DELIMITER $$
CREATE PROCEDURE PatologiePiuComuni(IN _anno INT)
BEGIN
	/* si costruisce una tabella per il periodo primaverile-estivo
		degli ultimi anni nel quale si trovano 
	*/
    
    -- PASSO 1: SI DIVIDONO LE DIAGNOSI IN DIAGNOSI ESTIVE E DIAGNOSI INVERNALI.
    DROP TABLE IF EXISTS DiagnosiEstive;
    CREATE TABLE DiagnosiEstive AS 
		(SELECT * FROM Diagnosi D WHERE MONTH(D.TimestampDiagnosi) BETWEEN 3 AND 9 AND YEAR(D.TimestampDiagnosi) > _anno);
	 
	DROP TABLE IF EXISTS DiagnosiInvernali;
    CREATE TABLE DiagnosiInvernali AS
		(SELECT * FROM Diagnosi D WHERE D.ID NOT IN (SELECT ID FROM DiagnosiEstive));
	
    -- PASSO 2: SI TROVANO LE PATOLOGIE PIÙ FREQUENTI PER OGNI PERIODO E IL NUMERO DI PIANTE COLPITE
    
    CREATE OR REPLACE VIEW PatologieEstive AS
    (
     SELECT P.Nome AS NomePatologia, De.ID AS Diagnosi, De.Pianta
     FROM DiagnosiEstive De
		INNER JOIN Ipotesi I 
			ON I.Diagnosi = De.ID
        INNER JOIN Patologia P
			ON P.Nome = I.Patologia
	WHERE I.Certezza = (SELECT MAX(Certezza) FROM Ipotesi WHERE Ipotesi.Diagnosi = De.ID)
	);
    
    CREATE OR REPLACE VIEW PatologieInvernali AS
    (
		SELECT P.Nome AS NomePatologia, Di.ID AS Diagnosi, Di.Pianta
        FROM DiagnosiInvernali Di
		INNER JOIN Ipotesi I 
			ON I.Diagnosi = Di.ID
        INNER JOIN Patologia P
			ON P.Nome = I.Patologia
		WHERE I.Certezza = (SELECT MAX(Certezza) FROM Ipotesi WHERE Ipotesi.Diagnosi = Di.ID)
    );
    
    DROP TABLE IF EXISTS FrequenzaPatologie;
    CREATE TABLE FrequenzaPatologie
    (
		Patologia VARCHAR(50),
        Frequenza INT,
        NumeroPianteColpite INT,
        Periodo ENUM('Estivo','Invernale')
	);
    
	INSERT INTO FrequenzaPatologie
    (
		SELECT PE.NomePatologia, COUNT(*),(
											SELECT COUNT(Pianta) 
											FROM PatologieEstive 
                                            WHERE NomePatologia = PE.NomePatologia
										   ),'Estivo'
        FROM PatologieEstive PE
        GROUP BY PE.NomePatologia
        );
	INSERT INTO FrequenzaPatologie
		(
		SELECT PI.NomePatologia, COUNT(*),(
											SELECT COUNT(Pianta) 
                                            FROM PatologieEstive 
                                            WHERE NomePatologia = PI.NomePatologia
										   ),'Invernale'
        FROM PatologieInvernali PI
        GROUP BY PI.NomePatologia
        );
	
    DROP VIEW PatologieEstive;
    DROP VIEW PatologieInvernali;
    
    
    -- PASSO 4: SI SCELGONO LE TRE PATOLOGIE PIU RISCONTRATE E LE TRE PIU DIFFUSE
    
	DROP TABLE IF EXISTS PatologiePiuRiscontrate;
    CREATE TABLE PatologiePiuRiscontrate AS 
		( SELECT * FROM FrequenzaPatologie ORDER BY Frequenza DESC LIMIT 3 );
    
	DROP TABLE IF EXISTS PatologiePiuDiffuse;
    CREATE TABLE PatologiePiuDiffuse AS 
		(SELECT * FROM FrequenzaPatologie ORDER BY NumeroPianteColpite DESC LIMIT 3);
    
    /* Si suppone che le patologie che hanno colpito un grande numero di piante siano
	   dovute più al periodo che agli elementi nel contenitore.
       Se una patologia ha invece colpito poche piante ma è stata comunque riscontrata
       spesso si deduce che ciascun esemplare si è ammalato più volte. Si controlla
    */
    
END$$
DELIMITER ;
    
-- STORED PROCEDURE: CREAZIONE DI UN ORDINE CONTENENTE TUTTE LE PIANTE IN UN PROSPETTO

USE ACME;

DROP PROCEDURE IF EXISTS AcquistaProspetto;

DELIMITER $$
CREATE PROCEDURE AcquistaProspetto (IN _CodiceProspetto INT)
BEGIN
	DECLARE END_OF_RESULTSET BOOL DEFAULT FALSE;
    DECLARE _numPiante INT DEFAULT 0;
    DECLARE _codCatalogo INT DEFAULT 0;
	DECLARE _nickname VARCHAR(20) DEFAULT "";
    DECLARE CursoreQuantitativiPiante CURSOR FOR (SELECT * FROM QuantitativiPiante);
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET END_OF_RESULTSET = TRUE;
	SET @OrdinePendente = FALSE;
    SET _nickname = 
		(
		SELECT AccountCliente
		FROM Prospetto 
		WHERE ID = _CodiceProspetto
		);
	
    DROP TABLE IF EXISTS PianteDaCatalogo;
	CREATE TABLE PianteDaCatalogo 
		(
		ID INT NOT NULL AUTO_INCREMENT,
		CodiceCatalogo INT NOT NULL,
        PRIMARY KEY (ID)
        );
	DROP TABLE IF EXISTS QuantitativiPiante;
	CREATE TABLE QuantitativiPiante LIKE PianteDaCatalogo;


    INSERT INTO PianteDaCatalogo(CodiceCatalogo)
		(
		SELECT AccoglieCatalogo.CatalogoPiante
        FROM Prospetto
			INNER JOIN Spazio ON Spazio.Prospetto = Prospetto.ID
            INNER JOIN Settore ON Settore.Spazio = Spazio.ID
            INNER JOIN AccoglieCatalogo ON AccoglieCatalogo.Settore = Settore.ID
		WHERE Prospetto.ID = _CodiceProspetto
        );
        
	INSERT INTO PianteDaCatalogo(CodiceCatalogo)
		(
		SELECT OspitaCatalogo.CatalogoPiante
        FROM Prospetto
			INNER JOIN Spazio ON Spazio.Prospetto = Prospetto.ID
            INNER JOIN Settore ON Settore.Spazio = Spazio.ID
            INNER JOIN Vaso ON Vaso.Settore = Spazio.ID
            INNER JOIN OspitaCatalogo ON OspitaCatalogo.Vaso = Vaso.ID
		WHERE Prospetto.ID = _CodiceProspetto
        );
        
    INSERT INTO QuantitativiPiante
		(
			SELECT CodiceCatalogo, COUNT(*) AS Quantitativo
            FROM PianteDaCatalogo
            GROUP BY CodiceCatalogo
		);
	
	INSERT INTO	Ordine(AccountCliente,Stato,ImportoTotale)
		VALUES (_nickname,'In Processazione',0);
	SET @IdOrdine = (SELECT MAX(ID) FROM Ordine);
	OPEN CursoreQuantitativiPiante;
	scan: LOOP
		FETCH CursoreQuantitativiPiante INTO _codCatalogo, _numPiante;
        IF END_OF_RESULTSET THEN 
			LEAVE scan;
		END IF;
        SET @PianteInserite = 0;
        SET @NumPianteDisponibili = 
			(
				SELECT COUNT(*) 
                FROM Pianta
				WHERE Pianta.CatalogoPiante = _codCatalogo
				AND Pianta.Codice NOT IN (SELECT Pianta FROM Articolo)
			);
		WHILE @NumPianteDisponibili > 0 AND @PianteInserite < _numPiante DO
			INSERT INTO Articolo -- CREARE ORDINE
			(
				SELECT Codice, @IdOrdine
                FROM Pianta
                WHERE Pianta.CatalogoPiante = _codCatalogo
					AND Pianta.Codice NOT IN (SELECT Pianta FROM Articolo)
				LIMIT 1
			);
            SET @NumPianteDisponibili = @NumPianteDisponibili - 1;
            SET @PianteInserite = @PianteInserite +1;
		END WHILE;
        WHILE @PianteInserite < _numPiante DO
			SET @OrdinePendente = TRUE;
			INSERT INTO ArticoloPendente(CatalogoPiante,Ordine)
				VALUES(_codCatalogo,@IdOrdine);
			SET @PianteInserite = @PianteInserite + 1;
		END WHILE;
	END LOOP;
    CLOSE CursoreQuantitativiPiante;
    IF(@OrdinePendente) THEN
		UPDATE Ordine
        SET Stato = 'Pendente' WHERE ID = @IdOrdine;
	END IF;
END $$
DELIMITER ;
            
-- STORED PROCEDURE: SET CONSISTENZA E PERMEABILITA N CONTENITORI

USE ACME;

DROP PROCEDURE IF EXISTS TerrenoContenitore;
DROP PROCEDURE IF EXISTS SetConsistenzaPermeabilita;

DELIMITER $$

CREATE PROCEDURE TerrenoContenitore(IN _CodiceContenitore INT)

BEGIN
	
    DECLARE _Elementi INT DEFAULT 0;
    
    DROP TABLE IF EXISTS _Composizione;
    CREATE TEMPORARY TABLE _Composizione(
		Terreno VARCHAR(20),
		Percentuale FLOAT (4,2)
        );
	
    DROP TABLE IF EXISTS _Composizione2;
	CREATE TEMPORARY TABLE _Composizione2(
		Terreno VARCHAR(20),
		Percentuale FLOAT (4,2)
        );
	
    INSERT INTO _Composizione
		SELECT Terreno,Percentuale
		FROM ComposizioneSubstrato
		WHERE Contenitore = _CodiceContenitore AND Percentuale > 30
		ORDER BY Percentuale;
	INSERT INTO _Composizione2
		SELECT Terreno,Percentuale
		FROM ComposizioneSubstrato
		WHERE Contenitore = _CodiceContenitore AND Percentuale > 30
		ORDER BY Percentuale;
        
    SET _Elementi = (
		SELECT count(*)
        FROM _Composizione2
        );

    IF _Elementi = 0 THEN
		
        BEGIN
			UPDATE Contenitore
			SET ConsistenzaSubstrato = 'Intermedio', PermeabilitaTerreno = 'Media'
			WHERE Codice = _CodiceContenitore;
			
		END;
    
	ELSEIF _Elementi = 1 THEN 
    
		BEGIN
			IF(SELECT Terreno FROM _Composizione LIMIT 1) = 'Argilla' THEN
            
				BEGIN
					UPDATE Contenitore
					SET ConsistenzaSubstrato = 'Compatto', PermeabilitaTerreno = 'Bassa'
					WHERE Codice = _CodiceContenitore;
				END;
                
			ELSEIF (SELECT Terreno FROM _Composizione LIMIT 1) = 'Sabbia' THEN
				
				BEGIN
					UPDATE Contenitore
					SET ConsistenzaSubstrato = 'Friabile', PermeabilitaTerreno = 'Alta'
					WHERE Codice = _CodiceContenitore;
				END;
                
			ELSE
            
				BEGIN
					UPDATE Contenitore
					SET ConsistenzaSubstrato = 'Intermedio', PermeabilitaTerreno = 'Alta'
					WHERE Codice = _CodiceContenitore;
				END;
                
			END IF;
            
		END;
	
    ELSEIF _Elementi = 2 THEN
	
		BEGIN

			IF(SELECT Percentuale FROM _Composizione ORDER BY Percentuale LIMIT 1) > 60 AND (SELECT Terreno FROM _Composizione ORDER BY Percentuale LIMIT 1) = 'Argilla' THEN
						
				BEGIN
					UPDATE Contenitore
					SET ConsistenzaSubstrato = 'Compatto', PermeabilitaTerreno = 'Bassa'
					WHERE Codice = _CodiceContenitore;
				END;
                        
			ELSEIF(SELECT Percentuale FROM _Composizione ORDER BY Percentuale LIMIT 1) > 60 AND (SELECT Terreno FROM _Composizione ORDER BY Percentuale LIMIT 1) = 'Sabbia' THEN
					
				BEGIN
					UPDATE Contenitore
					SET ConsistenzaSubstrato = 'Friabile', PermeabilitaTerreno = 'Alta'
					WHERE Codice = _CodiceContenitore;
				END;
				
			ELSEIF(SELECT Percentuale FROM _Composizione ORDER BY Percentuale LIMIT 1) > 60 THEN
                    
				BEGIN
					UPDATE Contenitore
					SET ConsistenzaSubstrato = 'Intermedio', PermeabilitaTerreno = 'Alta'
					WHERE Codice = _CodiceContenitore;
				END;
                        
			ELSEIF(SELECT Elemento FROM _Composizione ORDER BY Elemento LIMIT 1) = 'Argilla' OR (SELECT Elemento FROM _Composizione ORDER BY Elemento LIMIT 1 OFFSET 1) = 'Argilla' THEN
                    
				BEGIN
					UPDATE Contenitore
					SET ConsistenzaSubstrato = 'Intermedio', PermeabilitaTerreno = 'Media'
					WHERE Codice = _CodiceContenitore;
				END;
					
			ELSE
						
				BEGIN
					UPDATE Contenitore
					SET ConsistenzaSubstrato = 'Intermedio', PermeabilitaTerreno = 'Alta'
					WHERE Codice = _CodiceContenitore;
				END;
			
			END IF;
            
            TRUNCATE TABLE _Composizione;
            
		END;
        
	ELSE 
    
		BEGIN
			UPDATE Contenitore
			SET ConsistenzaSubstrato = 'Intermedio', PermeabilitaTerreno = 'Alta'
			WHERE Codice = _CodiceContenitore;
            
		END;
        
	END IF;
    
	TRUNCATE TABLE _Composizione;
    TRUNCATE TABLE _Composizione2;

END $$


CREATE PROCEDURE SetConsistenzaPermeabilita(IN NumContenitori INT)
	BEGIN
    DECLARE _i INT DEFAULT 1;
    WHILE _i < NumContenitori DO
		CALL TerrenoContenitore(_i);
        SET _i = _i + 1;
	END WHILE;
END $$

DELIMITER ;        
        
-- STORED PROCEDURE: CALCOLO INDICE MANUTENZIONE (FORMULA IN DOCUMENTAZIONE)

USE ACME;

DROP PROCEDURE IF EXISTS CalcoloIndiceManutenzione;

DELIMITER $$

CREATE PROCEDURE CalcoloIndiceManutenzione()
BEGIN
	DECLARE _indiceAccRad INT;
    DECLARE _indiceAccAereo INT;
    DECLARE _dimMax INT;
    DECLARE _codice INT;
    
	DECLARE END_OF_RESULTSET INT DEFAULT 0;
	DECLARE CursoreCatalogoPiante 
		CURSOR FOR (SELECT ID, DimMax, IndAereo, IndRadicale FROM CatalogoPiante);
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET END_OF_RESULTSET=1;
	OPEN CursoreCatalogoPiante;
	scan: LOOP
		FETCH CursoreCatalogoPiante INTO _codice, _dimMax, _indiceAccAereo, _indiceAccRad;
		IF END_OF_RESULTSET=1 THEN
			LEAVE scan;
		END IF;
        SET @numPeriodiFrutt = 
			(
				SELECT COUNT(*) FROM PeriodoFruttificazione WHERE CatalogoPiante = _codice
			);
        SET @indMan = 1 + (1 + @numPeriodiFrutt) * _indiceAccAereo * LOG(_dimMax);
        UPDATE CatalogoPiante
        SET CatalogoPiante.IndManutenzione = @indMan
        WHERE CatalogoPiante.ID = _codice;
        END LOOP;
END$$

DELIMITER ;
        
-- OPERAZIONE 1: CONTROLLO PRESENZA ESEMPLARI IN SERRA

DROP PROCEDURE IF EXISTS ControllaPresenzaEsemplari;

delimiter $$

CREATE PROCEDURE ControllaPresenzaEsemplari(IN _codspecie INT, IN _codserra INT)
BEGIN
    
    DECLARE NumPiante INT;
    
    SET NumPiante = ( 
		SELECT COUNT(*)
		FROM Pianta 
		WHERE CatalogoPiante = _codspecie AND Serra = _codserra);
        
   
	IF NumPiante > 0 THEN
		SELECT CONCAT('Sono presenti ', Numpiante, ' piante della specie ', _codspecie, ' nella serra ', _codserra) AS Messaggio;
	ELSE 
		SELECT CONCAT('Non è presente nessun esemplare della specie ', _codspecie, ' nella serra ', _codserra) AS Messaggio;
	END IF;
	
END$$

delimiter ;        
        
-- OPERAZIONE 2: CREAZIONE ORDINE CON ARTICOLI PENDENTI

USE ACME;

DROP PROCEDURE IF EXISTS CreazioneOrdineVuoto;
DROP PROCEDURE IF EXISTS AggiuntaArticoliEsemplare;
DROP PROCEDURE IF EXISTS AggiuntaArticoliNonDispo;
DROP TRIGGER IF EXISTS ArrivoPiantaNecessaria;

DELIMITER $$

CREATE PROCEDURE CreazioneOrdineVuoto (IN _CodUtente INT, INOUT _IDOrdine INT)

BEGIN
	
    INSERT INTO Ordine (AccountCliente, ImportoTotale, Stato, TimestampEvasione)
		VALUES (_CodUtente, 0, 'In Processazione', NULL);
        
	SELECT ID INTO _IDOrdine
    FROM Ordine
    WHERE AccountCliente = _CodUtente AND ImportoTotale = '0';

END $$

CREATE PROCEDURE AggiuntaArticoliEsemplare (IN _IDOrdine INT, IN CodEsemplare INT)

BEGIN
	
    DECLARE _ImportoTot INT;
    
    SET _ImportoTot = (
		SELECT ImportoTotale
        FROM Ordine
        WHERE ID = _IDOrdine
        ) + (
        SELECT Prezzo
        FROM Prezzo 
        WHERE CatalogoPiante = (SELECT CatalogoPiante FROM Pianta WHERE Codice = CodEsemplare)
			  AND Dimensione = (SELECT DimAttuale FROM Pianta WHERE Codice = CodEsemplare)
              );
	
    INSERT INTO Articolo
		VALUES (CodEsemplare, _IDOrdine);
        
	UPDATE Ordine
    SET ImportoTotale = _Importotot
    WHERE ID = _IDOrdine;
		
END $$

CREATE PROCEDURE AggiuntaArticoliNonDispo (IN _IDOrdine INT, IN _CodSpecie INT, IN Dimensione ENUM('Piccola','Media','Grande'), IN Sesso ENUM('M','F'))

BEGIN

	INSERT INTO ArticoloPendente (CatalogoPiante, Ordine, Dimensione, Sesso)
		VALUES (_CodSpecie, _IDOrdine, Dimensione, Sesso);
	
    UPDATE Ordine
    SET Stato = 'Pendente'
    WHERE ID = _IDOrdine;


END $$

CREATE TRIGGER ArrivoPiantaNecessaria AFTER INSERT ON Pianta
FOR EACH ROW
BEGIN

	
    DECLARE IDArticolo INT;
    DECLARE Finito INT DEFAULT 0;
    
    DECLARE scorriArticoliPendenti CURSOR FOR
		SELECT ID
        FROM ArticoloPendente
        ORDER BY Ordine;
        
        
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET Finito = 1;
    
    OPEN scorriArticoliPendenti;
    
        
	controlla: LOOP
		FETCH scorriArticoliPendenti INTO IDArticolo;
		IF Finito = 1 THEN 
			LEAVE controlla;
		END IF;
            
		SET @SpecieA = (SELECT CatalogoPiante FROM ArticoloPendente WHERE ID = IDArticolo);
        SET @DimA = (SELECT Dimensione FROM ArticoloPendente WHERE ID = IDArticolo);
        SET @SessoA = (SELECT Sesso FROM ArticoloPendente WHERE ID = IDArticolo);
        SET @IDOrdine = (SELECT Ordine FROM ArticoloPendente WHERE ID = IDArticolo);
        
        
        IF NEW.CatalogoPiante = @SpecieA AND NEW.DimAttuale = @DimA AND NEW.Sesso = @SessoA THEN
			
                Call AggiuntaArticoliEsemplare(@IDOrdine, NEW.Codice);
				
                DELETE FROM ArticoloPendente
                WHERE ID = IDArticolo;
                
                IF (SELECT COUNT(*) FROM ArticoloPendente WHERE Ordine = @IDOrdine) = 0 THEN
					UPDATE Ordine
					SET Stato = 'In Processazione'
					WHERE ID = @IDOrdine;
				END IF;
                
                LEAVE controlla;
			
		END IF;
        
        END LOOP controlla;
	
    CLOSE scorriArticoliPendenti;


END$$

DELIMITER ;
        
-- OPERAZIONE 3: CREAZIONE NUOVO ACCOUNT UTENTE

/* (OP3) Creazione di un nuovo account (Interattiva) */

drop procedure if exists NuovoAccount;
DROP PROCEDURE IF EXISTS ControlloUnicitaNick;

delimiter $$

CREATE PROCEDURE ControlloUnicitaNick(IN Nickutente VARCHAR(20), INOUT Unico BOOL)
BEGIN
	
    DECLARE Finito INT DEFAULT 0;
    DECLARE Nick VARCHAR(20);
    DECLARE scorriUtenti CURSOR FOR
		SELECT Nickname
        FROM AccountCliente;
        
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET Finito = 1;
	
    OPEN scorriUtenti;
    
    controlla: LOOP
		FETCH scorriUtenti INTO Nick;
        IF Finito = 1 THEN
			LEAVE controlla;
		END IF;
        
        IF Nickutente = Nick THEN
			SET Unico = FALSE;
		END IF;
        
	END LOOP controlla;
	
    CLOSE scorriUtenti;

END$$

create procedure NuovoAccount(
    in _Nickname VARCHAR(20),
    in _PasswordLogin VARCHAR(20),
    in _DomSegreta VARCHAR (45),
    in _RispSegreta VARCHAR (20),
    in _Email VARCHAR(40),
    in _Nome VARCHAR(20),
    in _Cognome VARCHAR(20),
    in _Indirizzo VARCHAR(50),
    in _CittaResidenza VARCHAR(40)
    )
begin 
	
    DECLARE Unico BOOL DEFAULT TRUE;
    
    Call ControlloUnicitaNick(_Nickname, Unico);
    
    IF Unico = TRUE THEN
    
		insert into AccountCliente (MediaValutRisp, NumValRicevute, Nickname, PasswordLogin, DomSegreta, RispSegreta)
			values (NULL, NULL, _Nickname, _PasswordLogin, _DomSegreta, _RispSegreta);
            
		SET @CodiceCliente = (SELECT CodiceUtente FROM AccountCliente WHERE Nickname = _Nickname);
            
		insert into AnagraficaCliente(AccountCliente, Email, Nome, Cognome, Indirizzo, CittaResidenza)
			values (@CodiceCliente, _Email, _Nome, _Cognome, _Indirizzo, _CittaResidenza);
	ELSE
		SELECT ('Il nickname utente scelto è gia in uso') AS Messaggio;
	END IF;
    
end$$

delimiter ;

-- OPERAZIONE 4: AGGIORNAMENTO MEDIA E NUMERO VALUTAZIONE ACCOUNT

USE ACME;

DROP EVENT IF EXISTS AggiornaNumeroValutazioniRicevute;
DROP EVENT IF EXISTS AggiornaMediaValutazioniRicevute;

DELIMITER $$
CREATE EVENT AggiornaNumeroValutazioniRicevute
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
	UPDATE AccountUtente
    SET NumValRicevute = NumValRicevute + (SELECT COUNT(*)
										   FROM Valuta V
										   WHERE V.AccountCliente = CodiceUtente AND
												 dayofyear(V.TimestampValutazione) = dayofyear(current_timestamp())
                                                 AND YEAR(V.TimestampValutazione) = YEAR(current_timestamp()));
END$$
	
CREATE EVENT AggiornaMediaValutazioniRicevute
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
	UPDATE AccountUtente
    SET MediaValRicevute = (MediaValRicevute + (SELECT SUM(VOTO)
												FROM Valuta V
                                                WHERE V.AccountCliente = CodiceUtente AND
													  dayofyear(V.TimestampValutazione) = dayofyear(current_timestamp())
													  AND YEAR(V.TimestampValutazione) = YEAR(current_timestamp())))/NumValRicevute;
END$$
DELIMITER ;    

-- OPERAZIONE 5: RICERCA DIPENDENTE QUALIFICATO PER ESECUZIONE INTERVENTO E ASSEGNAMENTO

USE ACME;

DROP PROCEDURE IF EXISTS RicercaDipendenteQualificato;
DROP PROCEDURE IF EXISTS CercaDipQualDispo;
DROP PROCEDURE IF EXISTS CercaDipDispo;

DELIMITER $$

CREATE PROCEDURE CercaDipDispo(IN LocalitaIntervento VARCHAR(50), IN Intervento INT)

BEGIN

	DECLARE Finito INT DEFAULT 0;
    DECLARE _Dipendente CHAR (16);
    DECLARE scorriDipDispo CURSOR FOR
		SELECT D.CodiceFiscale
        FROM Dipendente D INNER JOIN Sede S ON D.Sede = S.Codice
		WHERE S.Indirizzo = LocalitaIntervento;
        
	
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET Finito = 1;
        
	OPEN scorriDipDispo;
    
    controlla: LOOP
		FETCH scorriDipDispo INTO _Dipendente;
		IF Finito = 1 THEN
			SELECT ('Tutti i dipendenti in zona sono impegnati');
			LEAVE controlla;
		END IF;
        
        SET @Occupato = (SELECT COUNT(*) FROM Disponibilita WHERE Dipendente = _Dipendente);
        
        IF @Occupato = 0 THEN
			INSERT INTO Disponibilita
				VALUES (_Dipendente, Intervento);
                
			LEAVE controlla;
		END IF;
	
    END LOOP controlla;
    
    CLOSE scorriDipDispo;
        

END $$

CREATE PROCEDURE CercaDipQualDispo(IN QualificaNecessaria VARCHAR (20), IN LocalitaIntervento VARCHAR (50), IN Intervento INT)

BEGIN
	
    DECLARE Finito INT DEFAULT 0;
    DECLARE _Dipendente CHAR(16);
    DECLARE scorriDipQualificati CURSOR FOR
		SELECT D.CodiceFiscale
        FROM Dipendente D INNER JOIN Sede S ON D.Sede = S.Codice
		WHERE D.Qualifica = QualificaNecessaria AND S.Indirizzo = LocalitaIntervento;
        
	
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET Finito = 1;
        
	OPEN scorriDipQualificati;
    
    controlla: LOOP
		FETCH scorriDipQualificati INTO _Dipendente;
		IF Finito = 1 THEN
			SELECT ('Tutti i dipendenti qualificati in zona sono impegnati');
			LEAVE controlla;
		END IF;
        
        SET @Occupato = (SELECT COUNT(*) FROM Disponibilita WHERE Dipendente = _Dipendente);
        
        IF @Occupato = 0 THEN
			INSERT INTO Disponibilita
				VALUES (_Dipendente, Intervento);
                
			LEAVE controlla;
		END IF;
	
    END LOOP controlla;
    
    CLOSE scorriDipQualificati;
        

END $$

CREATE PROCEDURE RicercaDipendenteQualificato(IN _intervento INT)

BEGIN
	
	DECLARE NecQualifica INT;
	DECLARE QualificaNecessaria VARCHAR (20);
	DECLARE LocalitaIntervento VARCHAR (50);
    DECLARE TotDipQualificati INT DEFAULT 0;
    DECLARE cfDipendente CHAR (16);
    
    SET NecQualifica = (
		SELECT COUNT(C.Qualifica)
		FROM CatalogoIntervento C INNER JOIN SchedaIntervento S ON S.CatalogoIntervento = C.Codice
        WHERE S.ID = _intervento
        );
        
	SET LocalitaIntervento = (
		SELECT Luogo
        FROM SchedaIntervento
        WHERE ID = _intervento
        );
    
	IF NecQualifica = 0 THEN
		Call CercaDipDispo(LocalitaIntervento, _intervento);
	ELSE
    
    SET QualificaNecessaria = (
		SELECT C.Qualifica
		FROM CatalogoIntervento C INNER JOIN SchedaIntervento S ON S.CatalogoIntervento = C.Codice
        WHERE S.ID = _intervento
        );
    
    SET TotDipQualificati = (
		SELECT COUNT(*)
		FROM Dipendente D INNER JOIN Sede S ON D.Sede = S.Codice
		WHERE D.Qualifica = QualificaNecessaria AND S.Indirizzo = LocalitaIntervento
        );
    
    IF TotDipQualificati = 0 THEN
		SELECT ('Non ci sono dipendenti qualificati per tale intervento in zona');
	ELSE
		Call CercaDipQualDispo(QualificaNecessaria, LocalitaIntervento, _intervento);
	END IF;
    
    END IF;


END $$

DELIMITER ;
		
-- OPERAZIONE 7: CONTROLLO ELEMENTI IN UN CONTENITORE

USE ACME;

DROP PROCEDURE IF EXISTS ControlloElementi;
DROP PROCEDURE IF EXISTS ControllaPresenza;

DELIMITER $$

CREATE PROCEDURE ControllaPresenza(IN Elem VARCHAR(50), IN Dos FLOAT (4,2), IN _Contenitore INT, INOUT Errore TINYINT(1))

BEGIN
	
    DECLARE Finito INT DEFAULT 0;
    DECLARE _Elemento VARCHAR(50);
    DECLARE _Dose FLOAT (6,2);
    DECLARE cursoreComposizione CURSOR FOR
		SELECT Elemento, Dose
        FROM ComposizioneChimica
        WHERE Contenitore = _Contenitore;
        
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET Finito = 1;
        
	OPEN cursoreComposizione;
    
    SET Errore = 1;
    
    controlla: LOOP
		FETCH cursoreComposizione INTO _Elemento, _Dose;
		IF Finito = 1 THEN
			LEAVE controlla;
		END IF;
        
        SET @PPerc = _Dose + (_Dose/10);
        SET @MPerc = _Dose - (_Dose/10);
        
        IF _Elemento = Elem AND (Dos BETWEEN @PPerc AND @MPerc) THEN 
			SET Errore = 0;
            LEAVE controlla;
		END IF;
        
	END LOOP controlla;
    
    CLOSE cursoreComposizione;

END $$

CREATE PROCEDURE ControlloElementi(IN _CodiceContenitore INT)

BEGIN

	DECLARE Finito INT DEFAULT 0;
	DECLARE _CodPianta INT;
    DECLARE _CodSpecie INT;
    DECLARE _Elemento VARCHAR(50);
    DECLARE _Dose FLOAT (6,2);
    DECLARE _Errore TINYINT (1) DEFAULT 0;
    DECLARE _Mese INT;
    DECLARE _MeseInizio INT;
    DECLARE _MeseFine INT;
    DECLARE Contatore INT DEFAULT 0;
    
	DECLARE cursoreElementiNecessari CURSOR FOR
		SELECT Elemento, Dose, MeseInizio, MeseFine
        FROM Somministrazione
        WHERE CatalogoPiante = _CodSpecie;
        
	
    DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET Finito = 1;
    
    SET _CodPianta = (
		SELECT Pianta
        FROM Contenitore
        WHERE Codice = _CodiceContenitore
        );
        
	SET _CodSpecie = (
		SELECT CatalogoPiante
        FROM Pianta
        WHERE Codice = _CodPianta
        );
        
	SET _Mese = MONTH(current_date());
    
	IF _CodPianta IS NULL THEN
		SELECT 'Contenitore Vuoto' as Messaggio;
        SET _Errore = 1;
	ELSE
			SET @TotElemNec = (SELECT COUNT(*) FROM Somministrazione WHERE CatalogoPiante = _CodSpecie);
            SET @TotElemPres = (SELECT COUNT(*) FROM ComposizioneChimica WHERE Contenitore = _CodiceContenitore);
            
			IF @TotElemNec = 0 THEN
				SELECT ('Non sono state registrate le esigenze di elementi per la specie della pianta presente nel contenitore') as Messaggio;
				SET _Errore = 1;
			ELSE IF @TotElemPres = 0 THEN
				SELECT ('Non è presente alcun elemento nel contenitore') as Messaggio;
                SET _Errore = 1;
			ELSE 
        
				OPEN cursoreElementiNecessari;
            
				controlla: LOOP
                
					FETCH cursoreElementiNecessari INTO _Elemento, _Dose, _MeseInizio, _MeseFine;
					IF Finito = 1 THEN
						LEAVE controlla;
					END IF;
					
                    IF _MeseInizio IS NULL THEN
                    
						Call ControllaPresenza(_Elemento, _Dose, _CodiceContenitore, _Errore);
                        SET Contatore = Contatore + 1;
                        
					ELSE IF _Mese BETWEEN _MeseInizio AND _MeseFine THEN
                    
						Call ControllaPresenza(_Elemento, _Dose, _CodiceContenitore, _Errore);
                        SET Contatore = Contatore +1;
                        
					ELSE 
                    
						SELECT ('Non è previsto dosaggio per alcun elemento nel mese attuale, tuttavia il contenitore contiene alcuni elementi') as Messaggio;
                        SET _Errore = 1;
                        
					END IF;
                    END IF;
                
				END LOOP controlla;
            
				CLOSE cursoreElementiNecessari;
                
                IF _Errore = 1 THEN
					SELECT ('Gli elementi presenti non sono tutti quelli necessari o i loro dosaggi non corrispondono') as Messaggio;
				END IF;
			
            END IF;
			END IF;
            
	
    END IF;
    
    IF _Errore = 0 THEN
		SELECT ('Sono presenti tutti gli elementi necessari in dosaggi accettabili') as Messaggio;
		IF @TotElemPres > Contatore THEN
			SELECT (' Tuttavia nel contenitore sono presenti svariati elementi non necessari') as Messaggio;
		END IF;
	END IF;

END $$

DELIMITER ;
        
-- OPERAZIONE 8: CONTROLLO MANUTENZIONE NECESSARIA SU SCHEDAPIANTA CON MAN AUTO

USE ACME;

DROP PROCEDURE IF EXISTS ControlloManutenzione;

DELIMITER $$

CREATE PROCEDURE ControlloManutenzione(IN _IDSchedaPianta INT)

BEGIN

	DECLARE _IntDaEseguire INT;
    
	SELECT ManAuto INTO @Manut
    FROM SchedaPianta
    WHERE ID = _IDSchedaPianta;

	IF @Manut = FALSE THEN
		SELECT 'La pianta non è soggetta a manutenzione automatica';
	ELSE
		DROP TEMPORARY TABLE IF EXISTS _InterventiNec;
		CREATE TEMPORARY TABLE _InterventiNec(
			CatalogoIntervento INT 
            );
            
		INSERT INTO _InterventiNec
			SELECT CatalogoIntervento
            FROM PeriodoManutenzione 
            WHERE CatalogoPiante = (
									SELECT CatalogoPiante
                                    FROM SchedaPianta
                                    WHERE ID = _IDSchedaPianta);

		SET _IntDaEseguire = (
        SELECT COUNT(*) FROM (
        SELECT *
        FROM (
				SELECT *
                FROM _InterventiNec
                UNION ALL
				SELECT CatalogoIntervento
				FROM SchedaIntervento
				WHERE SchedaPianta = _IDSchedaPianta AND YEAR(DataEsecuzioneSopralluogo) = YEAR(current_date()) AND TipoPeriodicita = 'Automatica'
                ) tb1
		GROUP BY CatalogoIntervento
		HAVING count(*) = 1
        ) TB2
        );
	
        IF _IntDaEseguire > 0 THEN
			SELECT concat('Intervento mancante ', CatalogoIntervento) as Messaggio
			FROM (
				SELECT *
                FROM _InterventiNec
                UNION ALL
				SELECT CatalogoIntervento
				FROM SchedaIntervento
				WHERE SchedaPianta = _IDSchedaPianta AND YEAR(DataEsecuzioneSopralluogo) = YEAR(current_date()) AND TipoPeriodicita = 'Automatica'
                ) tb2
			GROUP BY CatalogoIntervento
			HAVING count(*) = 1;
		ELSE
			SELECT('Tutti gli interventi di manutenzione automatica necessari sono stati eseguiti');
		END IF;
        
        TRUNCATE TABLE _InterventiNec;

	END IF;

END $$

DELIMITER ;

-- EVENT: SEGNALAZIONE PIANTE COLPITE DA SINTOMI

USE ACME;

DELIMITER $$

CREATE EVENT IF NOT EXISTS SegnalazionePianteColpite

ON SCHEDULE EVERY 1 DAY

STARTS '2017-03-31 23:55:00'

DO
	BEGIN
		
        DECLARE _IDReport INT;
        DECLARE _IDdiagnosi INT;
		
        DECLARE CursoreDiagnosi CURSOR FOR
			SELECT ID
            FROM Diagnosi
            WHERE DAYOFYEAR(TimestampDiagnosi) = DAYOFYEAR(current_date()) 
				AND YEAR(TimestampDiagnosi) = YEAR(current_date());
        
		INSERT INTO ReportDiagnostica
			VALUES (current_timestamp());
        
        SET _IDReport = (
			SELECT ID
			FROM ReportDiagnostica
			WHERE TimestampReport = current_timestamp());
            
		OPEN CursoreDiagnosi;
        FETCH CursoreDiagnosi INTO _IDdiagnosi;
        
        UPDATE Diagnosi
        SET ReportDiagnostica = _IDReport
        WHERE ID = _IDdiagnosi;
        
        CLOSE CursoreDiagnosi;

    END $$
    
DELIMITER ;

-- EVENT ARCHIVIAZIONE POST, RISPOSTE E LINK

USE ACME;

-- EVENT settimanale che archivia i post, le risposte a loro relativi e i vari link datati oltre l'anno

DROP EVENT IF EXISTS ArchiviaPost;
DROP PROCEDURE IF EXISTS ArchiviaRisposte;
DROP PROCEDURE IF EXISTS ArchiviaLinkRisposta;
DROP PROCEDURE IF EXISTS ArchiviaLinkPost;
DROP PROCEDURE IF EXISTS ArchiviaValutazioni;

DELIMITER $$

CREATE PROCEDURE ArchiviaLinkPost (IN _Post INT, IN _PostArchivio INT)

BEGIN

	DECLARE Finito INT DEFAULT 0;
    DECLARE _IDLink INT;
        
	DECLARE scorriLink CURSOR FOR
		SELECT ID
		FROM LinkPost
		WHERE Post = _Post;
        
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET Finito = 1;
            
	OPEN scorriLink;
        
	preleva: LOOP
		FETCH scorriLink INTO _IDLink;
		IF Finito = 1 THEN
			LEAVE preleva;
		END IF;
        
		SET @URL = (SELECT URL FROM LinkPost WHERE ID = _IDLink);
        
        INSERT INTO LinkPostArchivio (PostArchivio, URL)
			VALUES (_PostArchivio, @URL);
		
        DELETE FROM LinkPost
        WHERE ID = _IDLink;
        
	END LOOP preleva;
    
    CLOSE scorriLink;

END $$

CREATE PROCEDURE ArchiviaValutazioni( IN _Post INT, IN _PostArchivio INT, IN _Risp INT, IN _RispArchivio INT)

BEGIN
	
    DECLARE Finito INT DEFAULT 0;
    DECLARE _AccValut INT;
        
	DECLARE scorriAcc CURSOR FOR
		SELECT AccountCliente
		FROM Valuta
		WHERE Post = _Post AND Risposta = _Risp;
        
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET Finito = 1;
            
	OPEN scorriAcc;
        
	preleva: LOOP
		FETCH scorriAcc INTO _AccValut;
		IF Finito = 1 THEN
			LEAVE preleva;
		END IF;

        SET @Voto = (SELECT Voto FROM Valuta WHERE Risposta = _Risp AND Post = _Post AND AccountCliente = _AccValut);
        SET @Times = (SELECT TimestampValutazione FROM Valuta WHERE Risposta = _Risp AND Post = _Post AND AccountCliente = _AccValut);
        
		INSERT INTO ValutaArchivio (PostArchivio, RispostaArchivio, AccountCliente, Testo, TimestampRisposta)
			VALUES (_PostArchivio, _RispArchivio, _AccValut, @Testo, @Times);
        
        DELETE FROM Valuta
        WHERE Post = _Post AND Risposta = _Risp AND AccountCliente = _AccValut;
        
    END LOOP preleva;
    
    CLOSE scorriAcc;
    

END $$

CREATE PROCEDURE ArchiviaLinkRisposta (IN _Post INT, IN _PostArchivio INT, IN _Risposta INT, IN _RispArchivio INT)

BEGIN

	DECLARE Finito INT DEFAULT 0;
    DECLARE _IDLink INT;
        
	DECLARE scorriLink CURSOR FOR
		SELECT ID
		FROM LinkRisposta
		WHERE Risposta = _Risposta AND Post = _Post;
        
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET Finito = 1;
            
	OPEN scorriLink;
        
	preleva: LOOP
		FETCH scorriLink INTO _IDLink;
		IF Finito = 1 THEN
			LEAVE preleva;
		END IF;
        
		SET @URL = (SELECT URL FROM LinkRisposta WHERE ID = _IDLink);
        
        INSERT INTO LinkRispArchivio (PostArchivio, RispostaArchivio, URL)
			VALUES (_Postarchivio, _RispArchivio, @URL);
		
        DELETE FROM LinkRisposta
        WHERE ID = _IDLink;
        
	END LOOP preleva;
    
    CLOSE scorriLink;
        

END $$

CREATE PROCEDURE ArchiviaRisposte (IN _PostArchiviato INT, IN _Post INT)

BEGIN

	DECLARE Finito INT DEFAULT 0;
    DECLARE _IDRisposte INT;
        
	DECLARE scorriRisposte CURSOR FOR
		SELECT ID
		FROM Risposta
		WHERE Post = _Post;
        
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET Finito = 1;
            
	OPEN scorriRisposte;
        
	preleva: LOOP
		FETCH scorriRisposte INTO _IDRisposte;
		IF Finito = 1 THEN
			LEAVE preleva;
		END IF;

		SET @AccountCliente = (SELECT AccountCliente FROM Risposta WHERE ID = _IDRisposte AND Post = _Post);
        SET @Testo = (SELECT Testo FROM Risposta WHERE ID = _IDRisposte AND Post = _Post);
        SET @Times = (SELECT TimestampRisposta FROM Risposta WHERE ID = _IDRisposte AND Post = _Post);
        
		INSERT INTO RispostaArchivio (PostArchivio, AccountCliente, Testo, TimestampRisposta)
			VALUES (_PostArchiviato, @AccountCliente, @Testo, @Times);
            
		SET @RispArchiviata = (SELECT ID FROM RispostaArchivio WHERE PostArchivio = _PostArchiviato AND AccountCliente = @AccountCliente AND TimestampRisposta = @Times);
		
        Call ArchiviaLinkRisposta (_Post, _PostArchiviato, _IDRisposte, @RispArchiviata);
        
        Call ArchiviaValutazioni(_Post, _PostArchiviato, _IDRisposte, @RispArchiviata);
        
        DELETE FROM Risposta
        WHERE ID = _IDRisposte AND Post = _Post;
        
    END LOOP preleva;
    
    CLOSE scorriRisposte;
	
END $$

CREATE EVENT ArchiviaPost

ON SCHEDULE EVERY 1 WEEK

STARTS '2018-03-31 23:55:00'  

DO
	BEGIN 
		
        DECLARE Finito INT DEFAULT 0;
        DECLARE _IDPost INT;
        
		DECLARE scorriPost CURSOR FOR
			SELECT ID
			FROM Post
			WHERE TimestampPost < SUBDATE(current_timestamp(), INTERVAL 1 YEAR);
        
		DECLARE CONTINUE HANDLER
			FOR NOT FOUND SET Finito = 1;
            
		OPEN scorriPost;
        
        preleva: LOOP
			FETCH scorriPost INTO _IDPost;
			IF Finito = 1 THEN
				LEAVE preleva;
			END IF;
            
            SET @AccountCliente = (SELECT AccountCliente FROM Post WHERE ID = _IDPost);
            SET @Times = (SELECT TimestampPost FROM Post WHERE ID = _IDPost);
            
            INSERT INTO PostArchivio (AccountCliente, Testo, TimestampPost)
				(SELECT AccountCliente, Testo, TimestampPost
				 FROM Post
				 WHERE ID = _IDPost);
                 
			SET @PostArchiviato = (SELECT ID FROM PostArchivio WHERE AccountCliente = @AccountCliente AND TimestampPost = @Times);
            
            Call ArchiviaRisposte (@PostArchiviato, _IDPost);
            
            Call ArchiviaLinkPost (_IDPost, @PostArchiviato);
            
            DELETE FROM Post
            WHERE ID = _IDPost;
            
		END LOOP preleva;
        
        CLOSE scorriPost;


	END $$

DELIMITER ;
            
-- ANALYTICS 1: "SMART" DESIGN

DROP PROCEDURE IF EXISTS ConfigurazionePossibile;
DROP TABLE IF EXISTS PiantePeriodiCosti;


CREATE TABLE PiantePeriodiCosti AS
(
	SELECT CatalogoPiante.ID, Prezzo.Prezzo, PeriodoFruttificazione.MeseInizio, PeriodoFruttificazione.MeseFine, CatalogoPiante.IndManutenzione
	FROM CatalogoPiante
		INNER JOIN PeriodoFruttificazione 
			ON CatalogoPiante.ID = PeriodoFruttificazione.CatalogoPiante
		INNER JOIN Prezzo
			ON Prezzo.CatalogoPiante = CatalogoPiante.ID
	WHERE Prezzo.Dimensione = 'Grande'
);

DELIMITER $$

CREATE PROCEDURE ConfigurazionePossibile
						(
						IN _codiceSettore INT,
                        IN _costoMassimo INT,
                        IN _indiceManutenzione ENUM('Basso','Medio','Alto')
						)
BEGIN
	DECLARE limiteIndiceManutenzione INT DEFAULT 0;
	DECLARE codicePianta INT DEFAULT 0;
    DECLARE prezzoPianta INT DEFAULT 0;
    DECLARE meseInizioPianta INT DEFAULT 0;
    DECLARE meseFinePianta INT DEFAULT 0;
	DECLARE END_OF_RESULTSET BOOL DEFAULT FALSE;
	DECLARE _LuceDirettaSettore BOOL;
    DECLARE _OreLuceSettore BOOL;
    DECLARE CursorePiante CURSOR FOR 
								(
								SELECT ID, Prezzo, MeseInizio, MeseFine
								FROM PiantePeriodiCosti 
                                WHERE IndManutenzione < limiteIndiceManutenzione
                                );
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET END_OF_RESULTSET = TRUE;
        
    CASE 
		WHEN _indiceManutenzione = 'Basso' THEN SET limiteIndiceManutenzione = 20;
		WHEN _indiceManutenzione = 'Medio' THEN SET limiteIndiceManutenzione = 30;
		WHEN _indiceManutenzione = 'Alto' THEN SET limiteIndiceManutenzione = 100;
    END CASE;	

    SELECT LuceDiretta, OreSole INTO _LuceDirettaSettore, _OreLuceSettore
    FROM Settore
    WHERE ID = _codiceSettore;
    
    DROP TABLE IF EXISTS Configurazione;
    CREATE TABLE Configurazione(
		Pianta INT NOT NULL,
        Costo INT NOT NULL
		);

    -- Calcolo area settore e stima approssimativa del numero di piante ospitabili -- 
    SET @AreaSettore = 0;
    CALL CalcoloAreaSettore(_codiceSettore,@AreaSettore);
    SET @MediaAreaPiante = (SELECT AVG(DimMax) FROM CatalogoPiante);
    SET @NumeroPianteOspitabili = FLOOR(@AreaSettore / @MediaAreaPiante);
    
    SET @NumeroPiantePeriodo = @NumeroPianteOspitabili / 3;
    SET @CostoTotale = 0;
    SET @P1 = 0; SET @P2 = 0; SET @P3 = 0;
    OPEN CursorePiante;
    preleva: LOOP
		FETCH CursorePiante INTO codicePianta, prezzoPianta, meseInizioPianta, meseFinePianta;
        IF END_OF_RESULTSET OR (@P1 = @P2 AND @P2 = @P3 AND @P3 = @NumeroPiantePeriodo) THEN
			LEAVE preleva;
		END IF;
		IF @CostoTotale + prezzoPianta < _costoMassimo THEN
			IF codicePianta NOT IN (SELECT * FROM Configurazione) THEN
				IF (meseInizioPianta BETWEEN 1 AND 4) AND (meseFinePianta BETWEEN 1 AND 4) THEN
                    IF @P1 >= @NumeroPiantePeriodo THEN
						ITERATE preleva;
					ELSE 
						SET @P1 = @P1 + 1;
						INSERT INTO Configurazione VALUES (@codicePianta, @prezzoPianta); 
					END IF;
				ELSE IF (meseInizioPianta BETWEEN 5 AND 9) AND (meseFinePianta BETWEEN 5 AND 9) THEN
                    IF @P2 >= @NumeroPiantePeriodo THEN
						ITERATE preleva;
					ELSE 
						SET @P2 = @P2 + 1;
						INSERT INTO Configurazione VALUES (@codicePianta, @prezzoPianta); 
					END IF;
				ELSE IF (meseInizioPianta BETWEEN 9 AND 12) AND (meseFinePianta BETWEEN 9 AND 12) THEN
                    IF @P3 >= @NumeroPiantePeriodo THEN
						ITERATE preleva;
					ELSE 
						SET @P3 = @P3 + 1;
						INSERT INTO Configurazione VALUES (codicePianta, prezzoPianta); 
					END IF;
				END IF;
			END IF;
		END IF;
        END IF;
        END IF;
	END LOOP;
    CLOSE CursorePiante;
    SELECT * FROM Configurazione;
END $$
DELIMITER ;

-- ANALYTICS 2: "SMART" WAREHOUSE MANAGEMENT

USE ACME;
DROP EVENT IF EXISTS SegnalazionePianteDeboli;

DELIMITER $$
CREATE EVENT SegnalazionePianteDeboli
	ON SCHEDULE EVERY 1 MONTH DO
BEGIN
	DROP TABLE IF EXISTS ClassificaPianteMalate;
    CREATE TABLE ClassificaPianteMalate 
	(
		CodicePianta INT,
		NomePianta VARCHAR(50),
        GenerePianta VARCHAR(50),
        CultivarPianta VARCHAR(50),
        NumeroDiagnosiEffettuate INT
	);
    
    INSERT INTO ClassificaPianteMalate(CodicePianta, NomePianta,GenerePianta,CultivarPianta,NumeroDiagnosiEffettuate)
    (
		SELECT CP2.Codice,CP2.Nome,CP2.Genere,CP2.Cultivar, TEMP.NumeroDiagnosi
		FROM CatalogoPiante CP2
		NATURAL JOIN
			(
			SELECT CP.ID,COUNT(*) AS NumeroDiagnosi
			FROM Diagnosi D
				INNER JOIN Ipotesi I ON I.Diagnosi = D.ID
				INNER JOIN Pianta P ON D.Pianta = P.Codice
				INNER JOIN CatalogoPiante CP ON CP.ID = P.CatalogoPiante
			WHERE MONTH(D.TimestampDiagnosi) = MONTH(CURRENT_DATE())
            AND I.Certezza = (SELECT MAX(Certezza) FROM Ipotesi WHERE ID = D.ID)
			GROUP BY CP.ID
		 	) AS TEMP
	);
    
    DROP TABLE IF EXISTS ClassificaPianteVendute;
    CREATE TABLE ClassificaPianteVendute
    	(
		CodicePianta INT,
		NomePianta VARCHAR(50),
        GenerePianta VARCHAR(50),
        CultivarPianta VARCHAR(50),
        NumeroEsemplariVenduti INT
		);
	INSERT INTO ClassificaPianteVendute
    (
		SELECT CP3.ID, CP3.Nome, CP3.Genere, CP4.Cultivar, TEMP2.EsemplariVenduti
			FROM CatalogoPiante CP3
			NATURAL JOIN
				(
				SELECT CP.ID,COUNT(*) AS EsemplariVenduti
				FROM Articolo A
					INNER JOIN Ordine O ON O.ID = Articolo.Ordine
					INNER JOIN Pianta P ON P.Codice = A.Pianta
					INNER JOIN CatalogoPiante CP ON CP.ID = P.CatalogoPiante
				WHERE MONTH(O.TimestampEvasione) = MONTH(CURRENT_DATE())
				GROUP BY CP.ID
				) AS TEMP2
	);
    DROP TABLE IF EXISTS PianteDaNonRiordinare;
    CREATE TABLE PianteDaNonRiordinare LIKE ClassificaPianteVendute;
	-- si effettua il rank su entrambe le tabelle e
	-- le ultime tre piante are cast into oblivion
	
    INSERT INTO PianteDaNonRiordinare
		(
		SELECT DD.CodicePianta
		FROM 
			(
				SELECT CPV.*,FIND_IN_SET(CPV.NumeroEsemplariVenduti, D.ListaVendite) AS Rank
				FROM ClassificaPianteVendute CPV, 
					(
						SELECT CPV2.ID, GROUP_CONCAT(
														CPV2.NumeroEsemplariVenduti 
														ORDER BY CPV2.NumeroEsemplariVenduti ASC
													) AS ListaVendite
						FROM ClassificaPianteVendute CPV2
						GROUP BY ID
					) AS D
				WHERE CPV.ID = D.ID
				) AS DD
		WHERE DD.Rank <= 3 AND DD.Rank > 0
		ORDER BY DD.ID, DD.Rank
		)
	UNION
    (
    SELECT EE.CodicePianta
    FROM 
		(
			SELECT CPM.*,FIND_IN_SET(CPM.NumeroDiagnosi, E.ListaDiagnosi) AS Rank
			FROM ClassificaPianteVendute CPM, 
				(
					SELECT CPM2.ID, GROUP_CONCAT(
													CPM2.NumeroEsemplariVenduti 
													ORDER BY CPM2.NumeroEsemplariVenduti ASC
												) AS ListaDiagnosi
					FROM CatalogoPianteVendute CPM2
                    GROUP BY ID
                    ) AS E
			WHERE CPM.ID = E.ID
            ) AS EE
	WHERE EE.Rank <= 3 AND EE.Rank > 0
    ORDER BY EE.ID, EE.Rank
    );
    
    
END$$
DELIMITER ;

-- ANALYTICS 3: STUDIO DI UNA PATOLOGIA

DROP PROCEDURE IF EXISTS DiagnosiPatologia;

DELIMITER $$
CREATE PROCEDURE DiagnosiPatologia (IN _patologia VARCHAR(50))
BEGIN

	-- PASSO 1: SI ELENCANO TUTTE LE DIAGNOSI PER LA PATOLOGIA IN INPUT
	DROP TABLE IF EXISTS DiagnosiPatologie;
    CREATE TABLE DiagnosiPatologie AS
		(
			SELECT D.ID AS IdDiagnosi, D.TimestampDiagnosi
            FROM Diagnosi D
            INNER JOIN Ipotesi I 
				ON I.Diagnosi = D.ID
			INNER JOIN Patologia P
				ON P.Nome = I.Patologia
			WHERE I.Certezza = 
				(
					SELECT MAX(Certezza)
					FROM Ipotesi I2
					WHERE I2.Diagnosi= D.ID
				)
			AND P.Nome = _patologia
			LIMIT 1
		);
	-- PASSO 2: JOIN CON LE CONDIZIONI DEL CONTENITORE (UMIDITA, ECC ECC)
	-- PER TROVARE LE POSSIBILI CAUSE
    
    DROP TABLE IF EXISTS CondizioniContenitorePiantaMalata;
    CREATE TABLE CondizioniContenitorePiantaMalata AS
		(
			SELECT *
			FROM DiagnosiPatologie DP
			INNER JOIN StoricoContenitore SC
				ON SC.PiantaContenuta = DP.Pianta
			WHERE DATE(DP.TimestampDiagnosi) =  DATE(SC.TimestampContenitore)
		);
END $$
DELIMITER ;


















        
	
	



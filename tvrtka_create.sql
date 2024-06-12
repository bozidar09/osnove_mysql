DROP DATABASE IF EXISTS tvrtka;  -- brisanje baze podataka ako postoji

CREATE DATABASE IF NOT EXISTS tvrtka DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;  -- stvaranje baze podataka ako ne postoji uz dodani set znakova utf8

USE tvrtka;

CREATE TABLE IF NOT EXISTS poslovnice ( -- kreiranje tablice/entiteta poslovnica ako ne postoji
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,  -- definiranje atributa id sa vrstom podataka (int unsigned - pozitivan cijeli broj, auto increment - sama baza podataka dodaje novi id, not null - vrijednost ne smije biti null, mora postojati) i označiti ga kao primarni ključ
    ime VARCHAR(20) NOT NULL,  -- tip podataka string u mysql-u (u ovom slučaju limitiran na 20)
    adresa VARCHAR(100) NOT NULL,
    broj_telefona VARCHAR(12),
    grad VARCHAR(20)
) ENGINE=InnoDB;  -- engine koji će koristiti ova tablica  

ALTER TABLE poslovnice DROP COLUMN broj_telefona; -- COLUMN je opcionalno
ALTER TABLE poslovnice DROP COLUMN grad;
ALTER TABLE poslovnice ADD COLUMN voditelj_id INT UNSIGNED NOT NULL; 
ALTER TABLE poslovnice ADD COLUMN grad_id INT UNSIGNED NOT NULL AFTER adresa; -- sa AFTER se definira gdje stavit novi column

CREATE TABLE IF NOT EXISTS gradovi ( 
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL, 
    ime VARCHAR(20) NOT NULL,  
    zip VARCHAR(10) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS zaposlenici ( 
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,  
    ime VARCHAR(50) NOT NULL,  
    adresa VARCHAR(100) NOT NULL,
    poslovnica_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (poslovnica_id) REFERENCES poslovnice(id),
    grad_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (grad_id) REFERENCES gradovi(id)
) ENGINE=InnoDB;

ALTER TABLE zaposlenici ADD FOREIGN KEY (voditelj_id) REFERENCES zaposlenici(id);
ALTER TABLE zaposlenici ADD FOREIGN KEY (grad_id) REFERENCES gradovi(id);
ALTER TABLE poslovnice ADD FOREIGN KEY (grad_id) REFERENCES gradovi(id);

ALTER TABLE poslovnice DROP FOREIGN KEY poslovnice_ibfk_1; -- brisanje prvog foreign keya 
ALTER TABLE poslovnice DROP COLUMN voditelj_id;
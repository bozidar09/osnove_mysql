-- primjer kreiranja i punjenja baze pomoću transakcije
-- početak transakcije
START TRANSACTION; 

-- stvaranje baze podataka
DROP DATABASE IF EXISTS tvrtka;

CREATE DATABASE IF NOT EXISTS tvrtka DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE tvrtka;

CREATE TABLE IF NOT EXISTS zaposlenik (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    oib CHAR(14) NOT NULL UNIQUE,
    ime VARCHAR(100) NOT NULL,
    adresa VARCHAR(100),
    telefon VARCHAR(12),
    datum_zaposlenja DATE NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS placa (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    zaposlenik_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zaposlenik_id) REFERENCES zaposlenik(id),
    osnovica DECIMAL(10,2) NOT NULL,
    datum_od DATE NOT NULL,
    datum_do DATE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pozicija (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    koeficijent FLOAT NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pozicija_popis (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    zaposlenik_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zaposlenik_id) REFERENCES zaposlenik(id),
    pozicija_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (pozicija_id) REFERENCES pozicija(id),
    datum_od DATE NOT NULL,
    datum_do DATE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS odjel (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL UNIQUE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS odjel_zaposlenik (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    odjel_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (odjel_id) REFERENCES odjel(id),
    zaposlenik_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zaposlenik_id) REFERENCES zaposlenik(id),
    datum_od DATE NOT NULL,
    datum_do DATE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS voditelj (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    odjel_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (odjel_id) REFERENCES odjel(id),
    zaposlenik_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zaposlenik_id) REFERENCES zaposlenik(id),
    datum_od DATE NOT NULL,
    datum_do DATE
)ENGINE=InnoDB;


-- punjenje baze sa podatcima

INSERT INTO zaposlenik (oib, ime, adresa, telefon, datum_zaposlenja) VALUES
('54678965257', 'Ivan Horvat', 'Ulica Kralja Zvonimira 10', '0912345678', '2021-05-17'),
('47474889543', 'Ana Kovač', 'Ulica Matije Gupca 15', '0912345679', '2021-05-17'),
('74367822578', 'Marko Marić', 'Ulica Ivana Gundulića 5', '0912345680', '2021-05-17'),
('96664346763', 'Petar Jurić', 'Ilica 79', '0912345681', '2021-09-23'),
('24455566777', 'Goran Matić', 'Ozaljska ulica 43 ', '0912345682', '2021-09-27'),
('68337889353', 'Lana Petrić', 'Fojnička ulica 76', '0912345683', '2022-02-05'),
('78563367732', 'Frane Šundov', 'Donje Svetice 53', '0912345684', '2022-03-11'),
('99675532556', 'Mirna Lukić', 'Draškovićeva ulica 9', '0912345685', '2022-07-29'),
('13356732344', 'Luka Šimić', 'Rudeška cesta 194', '0912345686', '2022-11-19'),
('34552214566', 'Petra Novak', 'Ulica Stjepana Radića 8', '0912345687', '2023-04-25'),
('48972506864', 'Marija Šulenta', 'Trnsko 117', '0912345688', '2023-09-19'),
('92328955322', 'Antonio Mikić', 'Lanište 5', '0912345689', '2024-05-26');

INSERT INTO pozicija (naziv, koeficijent) VALUES
('Human resources', 1.5),
('Team lead', 2.7),
('Backend senior', 2.2), 
('Frontend senior', 2.1), 
('Backend junior', 1.2), 
('Frontend junior', 1.1);

INSERT INTO odjel (naziv) VALUES
('Uprava'), 
('Frontend'), 
('Backend');

INSERT INTO voditelj (odjel_id, zaposlenik_id, datum_od, datum_do) VALUES
(3, 1, '2021-05-17', NULL),
(1, 2, '2021-05-17', NULL),
(2, 1, '2021-05-17', '2021-09-23'),
(2, 4, '2021-09-23', '2023-10-14'),
(2, 8, '2023-10-14', NULL);

INSERT INTO odjel_zaposlenik (odjel_id, zaposlenik_id, datum_od, datum_do) VALUES
(3, 1, '2021-05-17', NULL),
(1, 2,'2021-05-17', NULL),
(3, 3, '2021-05-17', '2022-08-29'),
(3, 5, '2021-09-27', NULL),
(2, 1, '2021-05-17', '2021-09-23'),
(2, 4, '2021-09-23', '2023-10-14'),
(3, 6, '2022-02-05', NULL),
(2, 7, '2022-03-11', NULL),
(2, 8, '2022-07-29', NULL),
(2, 3, '2022-08-29', '2023-04-01'),
(3, 9, '2022-11-19', NULL),
(1, 10, '2023-04-25', NULL),
(2, 11, '2023-09-19', NULL),
(3, 11, '2023-09-19', NULL),
(2, 12, '2024-05-26', NULL);

INSERT INTO placa (zaposlenik_id, osnovica, datum_od, datum_do) VALUES
(1, 1500, '2021-05-17', '2021-09-23'),
(1, 1000, '2021-09-23', '2022-04-01'),
(2, 1000, '2021-09-23', '2022-04-01'),
(3, 1000, '2021-05-17', '2022-04-01'),
(4, 1000, '2021-09-23', '2022-04-01'),
(5, 1000, '2021-09-27', '2022-04-01'),
(1, 1050, '2022-04-01', '2023-04-01'),
(2, 1050, '2022-04-01', '2023-04-01'),
(3, 1050, '2022-04-01', '2023-04-01'),
(4, 1050, '2022-04-01', '2023-04-01'),
(4, 1100, '2023-04-01', '2023-10-14'),
(5, 1050, '2022-04-01', '2023-04-01'),
(6, 1000, '2022-02-05', '2023-04-01'),
(7, 1000, '2022-03-11', '2023-04-01'),
(8, 1000, '2022-07-29', '2023-04-01'),
(1, 1100, '2023-04-01', '2024-04-01'),
(2, 1100, '2023-04-01', '2024-04-01'),
(5, 1100, '2023-04-01', '2024-04-01'),
(6, 1050, '2023-04-01', '2024-04-01'),
(7, 1050, '2023-04-01', '2024-04-01'),
(8, 1050, '2023-04-01', '2024-04-01'),
(9, 1000, '2022-11-19', '2024-04-01'),
(10, 1000, '2023-04-25', '2024-04-01'),
(11, 1000, '2023-09-19', '2024-04-01'),
(1, 1150, '2024-04-01', NULL),
(2, 1150, '2024-04-01', NULL),
(5, 1150, '2024-04-01', NULL),
(6, 1100, '2024-04-01', NULL),
(7, 1100, '2024-04-01', NULL),
(8, 1100, '2024-04-01', NULL),
(9, 1050, '2024-04-01', NULL),
(10, 1050, '2024-04-01', NULL),
(11, 1050, '2024-04-01', NULL),
(12, 1000, '2024-05-26', NULL); 

INSERT INTO pozicija_popis (zaposlenik_id, pozicija_id, datum_od, datum_do) VALUES
(1, 2, '2021-05-17', NULL),
(2, 1, '2021-05-17', NULL),
(3, 3, '2021-05-17', '2022-08-29'),
(4, 2, '2021-09-23', '2023-10-14'),
(5, 3, '2021-09-27', NULL),
(6, 3, '2022-02-05', NULL),
(7, 4, '2022-03-11', NULL),
(8, 4, '2022-07-29', '2023-10-14'),
(3, 4, '2022-08-29', '2023-04-01'),
(9, 5, '2022-11-19', '2024-04-01'),
(8, 2, '2023-10-14', NULL),
(10, 1, '2023-04-25', NULL),
(11, 6, '2023-09-19', NULL),
(9, 3, '2024-04-01', NULL),
(12, 6, '2024-05-26', NULL); 

-- izvršavanje transakcije
COMMIT; 
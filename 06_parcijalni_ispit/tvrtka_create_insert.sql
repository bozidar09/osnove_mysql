-- primjer kreiranja i punjenja baze pomoću transakcije
-- početak transakcije
START TRANSACTION; 

-- stvaranje baze podataka
DROP DATABASE IF EXISTS tvrtka;

CREATE DATABASE IF NOT EXISTS tvrtka DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE tvrtka;

CREATE TABLE IF NOT EXISTS radnik (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    oib CHAR(14) NOT NULL UNIQUE,
    ime VARCHAR(100) NOT NULL,
    adresa VARCHAR(100),
    telefon VARCHAR(12),
    datum_zaposlenja DATE NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pozicija (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    max_iznos DECIMAL(10,2) NOT NULL,
    min_iznos DECIMAL(10,2) NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS placa (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    radnik_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (radnik_id) REFERENCES radnik(id),
    pozicija_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (pozicija_id) REFERENCES pozicija(id),
    iznos DECIMAL(10,2) NOT NULL,
    datum_od DATE NOT NULL,
    datum_do DATE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS odjel (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL UNIQUE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS radnik_odjel (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    radnik_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (radnik_id) REFERENCES radnik(id),
    odjel_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (odjel_id) REFERENCES odjel(id),
    voditelj BOOLEAN DEFAULT FALSE,
    datum_od DATE NOT NULL,
    datum_do DATE
)ENGINE=InnoDB;


-- punjenje baze sa podatcima

INSERT INTO radnik (oib, ime, adresa, telefon, datum_zaposlenja) VALUES
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

INSERT INTO pozicija (naziv, max_iznos, min_iznos) VALUES
('Human resources', 2000, 1000),
('Team lead', 5000, 3000),
('Backend senior', 4000, 2000), 
('Frontend senior', 4000, 2000), 
('Backend junior', 1500, 1000), 
('Frontend junior', 1500, 1000);

INSERT INTO placa (radnik_id, pozicija_id, iznos, datum_od, datum_do) VALUES
(1, 2, 3050, '2021-05-17', '2022-04-01'),
(2, 1, 1200, '2021-09-23', '2022-04-01'),
(3, 3, 2000, '2021-05-17', '2022-04-01'),
(4, 2, 3000, '2021-09-23', '2022-04-01'),
(5, 3, 2000, '2021-09-27', '2022-04-01'),
(1, 2, 3200, '2022-04-01', '2023-04-01'),
(2, 1, 1300, '2022-04-01', '2023-04-01'),
(3, 3, 2150, '2022-04-01', '2022-08-29'),
(4, 2, 3150, '2022-04-01', '2023-04-01'),
(5, 3, 2100, '2022-04-01', '2023-04-01'),
(6, 3, 2000, '2022-02-05', '2023-04-01'),
(7, 4, 2000, '2022-03-11', '2023-04-01'),
(8, 4, 2050, '2022-07-29', '2023-04-01'),
(9, 5, 1000, '2022-11-19', '2023-04-01'),
(1, 2, 3400, '2023-04-01', '2024-04-01'),
(2, 1, 1400, '2023-04-01', '2024-04-01'),
(4, 2, 3300, '2023-04-01', '2023-10-14'),
(5, 3, 2250, '2023-04-01', '2024-04-01'),
(6, 3, 2100, '2023-04-01', '2024-04-01'),
(7, 4, 2050, '2023-04-01', '2024-04-01'),
(8, 4, 2200, '2023-04-01', '2023-10-14'),
(9, 5, 1100, '2023-04-01', '2024-04-01'),
(10, 1, 1000, '2023-04-25', '2024-04-01'),
(11, 6, 1000, '2023-09-19', '2024-04-01'),
(8, 2, 3000, '2023-10-14', '2024-04-01'),
(1, 2, 3550, '2024-04-01', NULL),
(2, 1, 1500, '2024-04-01', NULL),
(5, 3, 2400, '2024-04-01', NULL),
(6, 3, 2250, '2024-04-01', NULL),
(7, 4, 2200, '2024-04-01', NULL),
(8, 2, 3100, '2024-04-01', NULL),
(9, 5, 1200, '2024-04-01', NULL),
(10, 1, 1100, '2024-04-01', NULL),
(11, 6, 1100, '2024-04-01', NULL),
(12, 6, 1050, '2024-05-26', NULL); 

INSERT INTO odjel (naziv) VALUES
('Uprava'), 
('Frontend'), 
('Backend');

INSERT INTO radnik_odjel (radnik_id, odjel_id, voditelj, datum_od, datum_do) VALUES
(1, 3, TRUE, '2021-05-17', NULL),
(2, 1, TRUE, '2021-05-17', NULL),
(3, 3, FALSE, '2021-05-17', '2022-08-29'),
(5, 3, FALSE,'2021-09-27', NULL),
(1, 2, TRUE, '2021-05-17', '2021-09-23'),
(4, 2, TRUE, '2021-09-23', '2023-10-14'),
(6, 3, FALSE,'2022-02-05', NULL),
(7, 2, FALSE,'2022-03-11', NULL),
(8, 2, FALSE,'2022-07-29', '2023-10-14'),
(3, 2, FALSE,'2022-08-29', '2023-04-01'),
(9, 3, FALSE,'2022-11-19', NULL),
(10, 1, FALSE,'2023-04-25', NULL),
(11, 2, FALSE,'2023-09-19', NULL),
(11, 3, FALSE,'2023-09-19', NULL),
(8, 2, TRUE, '2023-10-14', NULL),
(12, 2, FALSE,'2024-05-26', NULL);

-- izvršavanje transakcije
COMMIT; 
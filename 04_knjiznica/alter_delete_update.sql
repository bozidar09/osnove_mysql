-- načini brisanja redaka, druge opcije ON DELETE (NO ACTION / SET NULL / DEFAULT / CASCADE)
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM clanovi WHERE clanovi.id = 4;
SET FOREIGN_KEY_CHECKS = 1;

-- načini brisanja stupaca/atributa
ALTER TABLE clanovi DROP COLUMN datum_rodjenja;

-- brisanje foreign key indeksa u tablici i potom brisanje stupca/atributa
ALTER TABLE clanovi DROP INDEX email;
ALTER TABLE knjige DROP FOREIGN KEY knjige_ibfk_1; 
ALTER TABLE knjige DROP COLUMN zanr_id;

-- brisanje tablice
DROP TABLE clanovi;

-- brisanje cijele baze
DROP DATABASE knjiznica;

-- brisanje svih podataka iz tablice
TRUNCATE posudbe;
DELETE FROM posudbe; -- može sa WHERE klauzulom za dodatno filtriranje

-- dodavanje stranog ključa
ALTER TABLE knjiga ADD FOREIGN KEY (zanr_id) REFERENCES zanrovi(id) ON DELETE CASCADE;

-- mijenjanje imena i tipa podatka postojećeg stupca
ALTER TABLE posudba CHANGE 'kopija_id' 'kopija_id' INT UNSIGNED NULL;

-- promjena vrijednosti u postojećim zapisima
UPDATE clanovi SET prezime = 'markovic', ime = 'bozidar' WHERE id = 1;
UPDATE clanovi SET datum_clanstva = CURDATE() WHERE id = 1;


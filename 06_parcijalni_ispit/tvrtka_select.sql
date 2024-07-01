
-- dohvatite sve radnike i njihove plaće (dodajemo i poziciju)
-- primjer stvaranja pogleda
CREATE OR REPLACE VIEW radnik_placa AS
    SELECT
        r.ime AS radnik,
        pz.naziv AS pozicija,
        pl.iznos AS placa
    FROM radnik r
        JOIN placa pl ON pl.radnik_id = r.id
        JOIN pozicija pz ON pl.pozicija_id = pz.id
    WHERE pl.datum_do IS NULL  -- filtriramo plaće trenutno zaposlenih radnika
    ORDER BY placa DESC;

-- prikaz svih podataka iz pogleda
SELECT * FROM radnik_placa;
--brisanje pogleda
DROP VIEW IF EXISTS radnik_placa;



-- dohvatite sve voditelje odjela i izračunajte prosjek njihovih plaća
-- primjer stvaranja procedure
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS voditelj_prosjek_placa()
BEGIN
    SELECT
        COUNT(DISTINCT(r.id)) AS broj_voditelja, 
        ROUND(AVG(pl.iznos), 2) AS prosjek_placa
    FROM radnik r
        JOIN radnik_odjel ro ON ro.radnik_id = r.id 
        JOIN placa pl ON pl.radnik_id = r.id
        JOIN pozicija pz ON pl.pozicija_id = pz.id
    WHERE pl.datum_do IS NULL AND ro.datum_do IS NULL AND ro.voditelj = TRUE;  -- filtriramo voditelje koji trenutno vode odjel i primaju plaću
END $$

DELIMITER ;

-- poziv procedure
CALL voditelj_prosjek_placa();
-- brisanje procedure
DROP PROCEDURE IF EXISTS voditelj_prosjek_placa;



-- kreirajte proceduru koja će računati prosjek plaća svih radnika
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS radnik_prosjek_placa()
BEGIN
    SELECT
        (SELECT COUNT(DISTINCT(ro.radnik_id)) FROM radnik_odjel ro WHERE ro.datum_do IS NULL) AS broj_radnika, -- u podupitu koristimo DISTINCT() kako ne bi više puta brojali one zaposlenike koji su zaposleni u više od jednog odjela
        ROUND(AVG(pl.iznos), 2) AS prosjek_placa
    FROM radnik r
        JOIN placa pl ON pl.radnik_id = r.id
        JOIN pozicija pz ON pl.pozicija_id = pz.id
    WHERE pl.datum_do IS NULL;
END $$

DELIMITER ;

CALL radnik_prosjek_placa();

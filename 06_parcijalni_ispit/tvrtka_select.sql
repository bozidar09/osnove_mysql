
-- dohvatite sve zaposlenike i njihove plaće (dodajemo i poziciju)
-- primjer stvaranja pogleda
CREATE OR REPLACE VIEW zaposlenik_placa AS
    SELECT
        z.ime AS zaposlenik,
        pz.naziv AS pozicija,
        ROUND(SUM(pl.osnovica * pz.koeficijent), 2) AS ukupna_placa
    FROM zaposlenik z
        JOIN odjel_zaposlenik oz ON oz.zaposlenik_id = z.id
        JOIN placa pl ON pl.zaposlenik_id = z.id
        JOIN pozicija_popis pp ON pp.zaposlenik_id = z.id
        JOIN pozicija pz ON pp.pozicija_id = pz.id
    WHERE oz.datum_do IS NULL AND pl.datum_do IS NULL AND pp.datum_do IS NULL  -- filtriramo trenutne odjele/plaće/pozicije
    GROUP BY z.id, pz.id 
    ORDER BY ukupna_placa DESC;

-- prikaz svih podataka iz pogleda
SELECT * FROM zaposlenik_placa;
--brisanje pogleda
DROP VIEW IF EXISTS zaposlenik_placa;



-- dohvatite sve voditelje odjela i izračunajte prosjek njihovih plaća
-- primjer stvaranja procedure
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS izracun_voditelj_placa()
BEGIN
    SELECT
        COUNT(DISTINCT(z.id)) AS 'Ukupno voditelja', -- koristimo DISTINCT() kako nebi više puta brojali one koji su voditelji više od jednog odjela (ako bi takvi postojali)
        ROUND((SUM(pl.osnovica * pz.koeficijent) / COUNT(DISTINCT(z.id))), 2) AS 'Prosjek placa' -- ne koristimo AVG() jer bi on podjelio ukupan zbroj plaća sa ukupnim brojem redaka (bez DISTINCT())
    FROM zaposlenik z
        JOIN voditelj v ON v.zaposlenik_id = z.id
        JOIN placa pl ON pl.zaposlenik_id = z.id
        JOIN pozicija_popis pp ON pp.zaposlenik_id = z.id
        JOIN pozicija pz ON pp.pozicija_id = pz.id
    WHERE v.datum_do IS NULL AND pl.datum_do IS NULL AND pp.datum_do IS NULL;
END $$

DELIMITER ;

-- poziv procedure
CALL izracun_voditelj_placa();
-- brisanje procedure
DROP PROCEDURE IF EXISTS izracun_voditelj_placa;



-- kreirajte proceduru koja će računati prosjek plaća svih zaposlenika
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS izracun_prosjecna_placa()
BEGIN
    SELECT
        COUNT(DISTINCT(z.id)) AS 'Ukupno zaposlenika', -- ponovno koristimo DISTINCT() kako nebi više puta brojali one zaposlenike koji su zaposleni u više od jednog odjela
        ROUND((SUM(pl.osnovica * pz.koeficijent) / COUNT(DISTINCT(z.id))), 2) AS 'Prosjek placa' -- ne koristimo AVG() jer bi on podjelio ukupan zbroj plaća sa ukupnim brojem redaka (bez DISTINCT())
    FROM zaposlenik z
        JOIN odjel_zaposlenik oz ON oz.zaposlenik_id = z.id
        JOIN placa pl ON pl.zaposlenik_id = z.id
        JOIN pozicija_popis pp ON pp.zaposlenik_id = z.id
        JOIN pozicija pz ON pp.pozicija_id = pz.id
    WHERE oz.datum_do IS NULL AND pl.datum_do IS NULL AND pp.datum_do IS NULL;
END $$

DELIMITER ;

CALL izracun_prosjecna_placa();

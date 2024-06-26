-- procedura za stvaranje nove posudbe
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS create_posudba(
    IN p_clan_id INT UNSIGNED,
    IN p_kopija_id INT UNSIGNED
)
BEGIN
    DECLARE v_posudba_id INT UNSIGNED;
    DECLARE v_kolicina INT;

-- početak transakcije
    START TRANSACTION;

-- provjera je li kopija dostupna
    SELECT count(f.id)
        INTO v_kolicina -- pohranjujemo rezultat u varijablu v_kolicina
        FROM kopija k
        JOIN filmovi f ON k.film_id = f.id
        JOIN mediji m ON k.medij_id = m.id
        WHERE m.tip = 'DVD' 
            AND k.dostupan = 1
            AND f.naslov = 'Inception'
        GROUP BY f.id
        FOR UPDATE; -- race condition (osigurava da nema stranih upisa u navedene tablice, zaključava ih dok se ne izvrši naša transakcija)

-- insert nove posudbe ako postoji dostupna kopija
    IF v_kolicina > 0 THEN
        INSERT INTO posudba (datum_posudbe, clan_id)
        VALUES (CURDATE(), p_clan_id);

        SET v_posudba_id = LAST_INSERT_ID(); -- spremanje posljednje unesenog id (posudba.id) u varijablu v_posudba_id

-- insert podataka u veznu tablicu posudba_kopija
        INSERT INTO posudba_kopija (posudba_id, kopija_id)
        VALUES (v_posudba_id, p_kopija_id);

-- update dostupnosti kopije
        UPDATE kopija
        SET dostupan = 0
        WHERE id = p_kopija_id;

-- izvršavanje transakcije
        COMMIT;
    ELSE
-- ako kopija nije dostupna otkazujemo izvršavanje transakcije i javljamo grešku
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available';
    END IF;
END $$

DELIMITER ;

-- poziv procedure
-- (clan_id, kopija_id)
CALL create_posudba(1, 2);





-- procedura za popravak stanja dostupnih kopija filma u odnosu na posudbe
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS update_kopija()
BEGIN
    UPDATE kopija 
        SET dostupan = 0
    WHERE id IN (
        SELECT kopija_id  -- primjer podupita
        FROM posudba_kopija
    );
END $$

DELIMITER ;

CALL update_kopija();





-- procedura za ispis prosjecne cijene filma
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS calculate_prosjecna_cijena()
BEGIN
    SELECT
        f.naslov,
        COUNT(k.id) AS broj_kopija,
        IFNULL(ROUND(AVG(CASE WHEN k.dostupan = 1 THEN  c.cijena * m.koeficijent END), 2), 0) AS prosjecna_cijena_dostupan,
        IFNULL(ROUND(AVG(CASE WHEN k.dostupan = 0 THEN c.cijena * m.koeficijent END), 2), 0) AS prosjecna_cijena_nedostupan
    FROM kopija k
        JOIN filmovi f ON k.film_id = f.id
        JOIN cjenik c ON f.cjenik_id = c.id
        JOIN mediji m ON k.medij_id = m.id
    GROUP BY f.id
    ORDER BY f.id;
END $$

DELIMITER ;

CALL calculate_prosjecna_cijena();

-- brisanje procedure
DROP PROCEDURE IF EXISTS calculate_prosjecna_cijena;
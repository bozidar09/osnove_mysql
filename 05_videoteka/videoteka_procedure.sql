
DELIMITER $$

CREATE PROCEDURE create_posudba(
    IN p_clan_id INT UNSIGNED,
    IN p_kopija_id INT UNSIGNED
)

BEGIN

    DECLARE v_posudba_id INT UNSIGNED;
    DECLARE v_kolicina INT;

    -- Start transaction
    START TRANSACTION;

    -- Ensure the film copy is available
    SELECT count(f.id)
        INTO v_kolicina
        FROM kopija k
        JOIN filmovi f ON k.film_id = f.id
        JOIN mediji m ON k.medij_id = m.id
        WHERE m.tip = 'DVD' 
            AND k.dostupan = 1
            AND f.naslov = 'Inception'
        GROUP BY f.id
    FOR UPDATE;

    IF v_kolicina > 0 THEN
        -- Insert the new borrowing record
        INSERT INTO posudba (datum_posudbe, clan_id)
        VALUES (CURDATE(), p_clan_id);

        SET v_posudba_id = LAST_INSERT_ID();

        -- Insert the kopija into posudba_kopija
        INSERT INTO posudba_kopija (posudba_id, kopija_id)
        VALUES (v_posudba_id, p_kopija_id);

        -- Update the availability of the kopija
        UPDATE kopija
        SET dostupan = 0
        WHERE id = p_kopija_id;

        -- Commit the transaction
        COMMIT;
    ELSE
        -- If a film copy is not available, rollback the transaction
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available';
    END IF;
    
END $$

DELIMITER ;


-- (clan_id, kopija_id)
CALL create_posudba(1, 2);

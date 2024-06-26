-- unos novog filma i podataka o njegovim kopijama
-- početak transakcije
START TRANSACTION; 

-- insert novog filma
INSERT INTO filmovi (naslov, godina, zanr_id, cjenik_id) 
VALUES ('Deadpool 3', '2024', 2, 2);

-- dohvati zadnji upisani id filma
SET @new_film_id = LAST_INSERT_ID();

-- popuni informacije o kopijama filma
INSERT INTO kopija (barcode, dostupan, film_id, medij_id) 
VALUES 
('DEAD3DVD', 1, @new_film_id, 1), 
('DEAD3BR', 1, @new_film_id, 2),
('DEAD3VHS', 1, @new_film_id, 3);

-- izvršavanje transakcije
COMMIT; 
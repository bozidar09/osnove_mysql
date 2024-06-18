-- create a new film with its associated stock (zaliha)
START TRANSACTION;

-- Insert the new film
INSERT INTO filmovi (naslov, godina, zanr_id, cjenik_id) 
VALUES ('Deadpool 3', '2024', 2, 2);

-- Get the last inserted film ID
SET @new_film_id = LAST_INSERT_ID();

-- Insert stock information
INSERT INTO zaliha (film_id, medij_id, kolicina) 
VALUES 
(@new_film_id, 1, 10), 
(@new_film_id, 2, 5),
(@new_film_id, 3, 15);

COMMIT;
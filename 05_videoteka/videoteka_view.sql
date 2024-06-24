CREATE VIEW film_na_dvd AS
    SELECT f.naslov, COUNT(f.id) AS 'broj kopija'
	FROM kopija k
	JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE m.tip = 'DVD' AND k.dostupan = 1
    GROUP BY f.id;

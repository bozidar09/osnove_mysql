CREATE VIEW film_dvd AS
    SELECT f.naslov, count(f.id) AS 'broj kopija'
        FROM kopija k
        JOIN filmovi f ON k.film_id = f.id
        JOIN mediji m ON k.medij_id = m.id
        WHERE m.tip = 'DVD' AND k.dostupan = 1
        GROUP BY f.id;

SELECT * FROM film_dvd;

CREATE VIEW dostupni_filmovi AS
    SELECT 
        f.id AS film_id,
        f.naslov AS naslov_filma,
        f.godina AS godina_filma,
        z.ime AS zanr,
        m.tip AS tip_medija,
        COUNT(CASE WHEN k.dostupan = 1 THEN 1 ELSE NULL END) AS dostupne_kopije,
        COUNT(CASE WHEN k.dostupan = 0 THEN 1 ELSE NULL END) AS posudjene_kopije
    FROM filmovi f
        JOIN zanrovi z ON f.zanr_id = z.id
        JOIN kopija k ON f.id = k.film_id
        JOIN mediji m ON k.medij_id = m.id
    GROUP BY f.id, m.tip
    ORDER BY f.id;

SELECT * FROM dostupni_filmovi;

--brisanje pogleda
DROP VIEW film_dvd;

-- dvije prednosti pogleda:
-- 1. podesavanje pristupa - sigurnost
-- 2. promjena strukture baze
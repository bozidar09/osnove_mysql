/* Dohvati sve (zapise i polja) podatke iz tablice filmovi */
SELECT * FROM filmovi;

/* Dohvati sve (zapise i polja) podatke iz tablice clanovi */
SELECT * FROM clanovi;

-- dohvati polja naslov, godina (kao aliase) iz tablice filmovi
SELECT naslov AS Naslov, godina as 'Godina izdanja' FROM filmovi;

-- dohvati samo prvi zapis iz tablice filmovi
SELECT * FROM filmovi LIMIT 1;

-- dohvati zapis iz tablice filmovi sa točno određenim naslovom
SELECT * FROM filmovi WHERE naslov='Inception';

-- dohvati zapis iz tablice filmovi gdje je id 2 ili 3 
SELECT * FROM filmovi WHERE id=2 OR id=3;
SELECT * FROM filmovi WHERE id IN (2,3);
SELECT * FROM filmovi WHERE id BETWEEN 2 AND 3;

-- dohvati zapis iz tablice clanovi gdje je ime Ivan i telefon je '0912345678'
SELECT * FROM clanovi WHERE ime='Ivan Horvat' AND telefon='0912345678';

-- prioritet operatora, AND ima veći prioritet
SELECT * FROM filmovi WHERE (id=1 OR id=2) AND naslov='Kum';

-- dohvati zapise iz tablice filmovi gdje je film noviji od godine 1990.
SELECT * FROM filmovi WHERE godina >= 1990;

-- dohvati zapise iz tablice filmovi gdje je film id različit od 2
SELECT * FROM filmovi WHERE id <> 2;
SELECT * FROM filmovi WHERE id != 2;

-- poredaj filmove po godinama uzlazno/silazno (ASC je default, DESC treba navesti)
SELECT * FROM filmovi ORDER BY godina;
SELECT * FROM filmovi ORDER BY godina DESC;

-- pretraži tablicu filmovi po dijelu naslova filma ('_' -> zamjenjuje točno jedan proizvoljan znak, a '%' -> 0, jedan ili više proizvoljnih)
SELECT * FROM filmovi WHERE naslov LIKE '_nce%';

-- COUNT, AVG, SUM
SELECT COUNT(id) AS "Broj filmova u bazi" FROM filmovi;
SELECT COUNT(id) AS "Broj filmova u bazi mladjih od 1990" FROM filmovi WHERE godina > 1990;

SELECT AVG(cijena) AS "Prosjek cijene" FROM cjenik;
SELECT FORMAT(AVG(cijena), 2) AS "Prosjek cijene formatiran" FROM cjenik; -- druga opcija ROUND() umjesto format, vraća INT umjesto CHAR

SELECT SUM(cijena) AS "Ukupna cijena" FROM cjenik; 

-- INNER JOIN (jedan i više njih u jednoj select naredbi)
SELECT f.naslov, f.godina, z.ime AS 'zanr'
    FROM filmovi f -- alias može i bez AS
    JOIN zanrovi z ON f.zanr_id = z.id

SELECT f.naslov, f.godina, z.ime AS 'zanr', c.cijena AS 'cijena', c.zakasnina_po_danu AS 'zakasnina'
    FROM filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id
    JOIN cjenik c ON f.cjenik_id = c.id;

-- JOIN sa funkcijom DATEDIFF (uz nju može LTRIM, CONCAT, a može i bez)
SELECT 
    cl.ime AS 'Ime', 
    f.naslov AS 'Film', 
    ps.datum_posudbe AS 'Datum posudbe', 
    ps.datum_povrata AS 'Datum povrata', 
    CONCAT(DATEDIFF(ps.datum_povrata, ps.datum_posudbe)-1) AS 'Kašnjenje (dana)', 
    CONCAT((DATEDIFF(ps.datum_povrata, ps.datum_posudbe)-1) * cj.zakasnina_po_danu + cj.cijena) AS 'Cijena'
        FROM posudba_kopija AS pk 
        JOIN posudba AS ps ON pk.posudba_id = ps.id
        JOIN clanovi AS cl ON ps.clan_id = cl.id 
        JOIN kopija AS k ON pk.kopija_id = k.id 
        JOIN filmovi AS f ON k.film_id = f.id
        JOIN cjenik AS cj ON f.cjenik_id = cj.id
        WHERE DATEDIFF(ps.datum_povrata, ps.datum_posudbe) >= 2; 

-- spoji tablicu posudba sa kopija, filmovi i mediji preko vezne tablice posudba_kopija
SELECT ps.datum_posudbe, ps.datum_povrata, cl.ime, f.naslov, m.tip
    FROM posudba_kopija AS pk 
    JOIN posudba AS ps ON pk.posudba_id = ps.id
    JOIN clanovi AS cl ON ps.clan_id = cl.id 
    JOIN kopija AS k ON pk.kopija_id = k.id 
    JOIN filmovi AS f ON k.film_id = f.id
    JOIN mediji AS m ON k.medij_id = m.id;


-- izlistaj posudbe i film naziv i medij za filmove koji nisu vraćeni
SELECT ps.datum_posudbe, ps.datum_povrata, cl.ime, f.naslov, m.tip
    FROM posudba_kopija AS pk 
    JOIN posudba AS ps ON pk.posudba_id = ps.id
    JOIN clanovi AS cl ON ps.clan_id = cl.id 
    JOIN kopija AS k ON pk.kopija_id = k.id 
    JOIN filmovi AS f ON k.film_id = f.id
    JOIN mediji AS m ON k.medij_id = m.id
    WHERE ps.datum_povrata IS NULL; -- sa NULL se uspoređuje pomoću 'IS NULL' i 'IS NOT NULL'

-- povezi sve tablice i izlistaj podatke
SELECT 
    ps.datum_posudbe, 
    ps.datum_povrata, 
    cl.ime AS 'ime clana', 
    f.naslov, 
    m.tip AS 'medij', 
    z.ime AS 'zanr', 
    cj.tip_filma, 
    cj.zakasnina_po_danu
        FROM posudba_kopija AS pk 
        JOIN posudba AS ps ON pk.posudba_id = ps.id
        JOIN clanovi AS cl ON ps.clan_id = cl.id 
        JOIN kopija AS k ON pk.kopija_id = k.id 
        JOIN mediji AS m ON k.medij_id = m.id
        JOIN filmovi AS f ON k.film_id = f.id
        JOIN cjenik AS cj ON f.cjenik_id = cj.id
        JOIN zanrovi AS z ON f.zanr_id = z.id;

-- ispiši članove koji su posudili više od jednog filma sa GROUP BY
SELECT c.id, c.ime AS 'clan', COUNT(*) AS "broj posudbi" -- može i sa COUNT(c.id) jer broji retke
    FROM posudba p
    JOIN clanovi c ON p.clan_id = c.id
    GROUP BY c.id
    HAVING COUNT(*) > 1;

-- ispišite totalnu količinu kopija dostupnih po filmu (zbroj svih medija) sa GROUP BY
SELECT f.id, f.naslov, COUNT(k.dostupan) AS "kolicina" -- može i SUM() kod kojeg se mora navesti točno određeni stupac koji će se zbrajati
    FROM filmovi f
    JOIN kopija k ON f.id = k.film_id
    GROUP BY f.id;

-- filtirajte gornji upit da izlista samo filmove koji imaju više od 5 kopija sa HAVING
SELECT f.id, f.naslov, COUNT(f.id) AS kolicina
    FROM filmovi f
    JOIN kopija k ON f.id = k.film_id
    GROUP BY f.id
    HAVING kolicina > 5; -- možemo iskoristiti alias u HAVING, ali on ne smije biti deklariran pod navodnicima

-- sastavljanje podupita - dohvati sve filmove koji imaju količinu na Blueray-u
-- prvi upit kojim dohvaćamo Blueray sa količinom
SELECT GROUP_CONCAT(k.film_id)  -- funkcija konkatenira sve dobivene rezultate (odvojene zarezom)
    FROM kopija k
    JOIN mediji m ON k.medij_id = m.id
    WHERE m.tip = 'Blu-Ray' AND k.dostupan = TRUE;
-- drugi upit gdje tražimo naslove filma
SELECT f.naslov
    FROM filmovi f
    WHERE f.id IN (1,2,3,3,4,4,5,6,6);
-- sastavljen upit s podupitom koji daje željeni rezultat
SELECT filmovi.naslov 
    FROM filmovi 
    WHERE filmovi.id IN (
        SELECT k.film_id 
            FROM kopija k 
            JOIN mediji m ON k.medij_id = m.id 
            WHERE m.tip = "Blu-Ray" AND k.dostupan = TRUE
        );

-- dohvati članove koji imaju ne vraćen film preko jednog dana (kasnjenje)
SELECT c.*, DATEDIFF(p.datum_povrata, p.datum_posudbe) - 1 AS "kasnjenje"
    FROM posudba p
    JOIN clanovi c ON c.id = p.clan_id
    WHERE DATEDIFF(p.datum_povrata, p.datum_posudbe) > 1 OR (p.datum_povrata IS NULL AND DATEDIFF(CURDATE(), p.datum_posudbe) > 1);

SELECT c.*, DATEDIFF(p.datum_povrata, p.datum_posudbe) - 1 AS "kasnjenje"
    FROM posudba p
    JOIN clanovi c ON c.id = p.clan_id
    WHERE DATEDIFF(p.datum_povrata, p.datum_posudbe) > 1 OR DATEDIFF(IFNULL(p.datum_povrata, CURDATE()), p.datum_posudbe) > 1; -- drugi način sa IFNULL() funkcijom

-- dohvati zapise iz filmova, preskoči prva 3 zapisa, dohvati sveukupno 2 zapisa
SELECT * FROM filmovi LIMIT 2 OFFSET 3;  -- može i sa LIMIT 3, 2 -> obrnuto je kod korištenja sa zarezom

-- if klauzula
SELECT *, IF (dostupan = TRUE, 'dostupna', 'nema je') AS dostupna
    FROM kopija;

-- dohvati količinu svih dostupnih filmova na određenom mediju (dvd)
SELECT f.naslov, COUNT(f.id) 
	FROM kopija k
	JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE m.tip = 'DVD' AND k.dostupan = 1
    GROUP BY f.id;

-- dohvati količinu dostupnih filmova po svakom mediju za film ID 1 (uz konkateniranje rezultata)
SELECT CONCAT(m.tip, ' ', COUNT(f.id)) AS 'kolicina'
	FROM kopija k
	JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE f.id = 1 AND k.dostupan = 1
    GROUP BY m.id;

-- za svaki film u bazi dohvatiti količinu dostupnih filmova po mediju
SELECT f.naslov, m.tip, COUNT(f.id) AS 'kolicina'
	FROM kopija k
	JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE k.dostupan = 1
    GROUP BY f.id, m.id;

-- dohvati prosječnu cijenu filmova s obzirom na ukupnu zalihu filmova
SELECT f.naslov, COUNT(k.id) AS 'broj kopija', ROUND(AVG(c.cijena * m.koeficijent), 2) AS 'prosjecna cijena'
    FROM kopija k
    JOIN filmovi f ON k.film_id = f.id
    JOIN cjenik c ON c.id = f.cjenik_id
    JOIN mediji m ON k.medij_id = m.id
    WHERE k.dostupan = 1
    GROUP BY f.id;

-- izlistati posudbe sa imenom člana i nazivom filma
SELECT p.*, c.ime, f.naslov 
    FROM posudba p
    JOIN clanovi c ON c.id = p.clan_id
    JOIN posudba_kopija pk ON p.id = pk.posudba_id
    JOIN kopija k ON k.id = pk.kopija_id
    JOIN filmovi f ON f.id = k.film_id;

SELECT p.*, c.ime, IFNULL(f.naslov, 'nema posudbe') -- primjer korištenja IFNULL fukcije (na "loš" način, kako bi ispravili narušen integritet baze)
    FROM posudba p
    JOIN clanovi c ON c.id = p.clan_id
    LEFT JOIN posudba_kopija pk ON p.id = pk.posudba_id
    LEFT JOIN kopija k ON k.id = pk.kopija_id
    LEFT JOIN filmovi f ON f.id = k.film_id;

-- korištenje IF funkcije
SELECT f.naslov, m.tip, COUNT(k.id) AS 'broj kopija', IF (COUNT(k.id) > 2, 'dovoljno na zalihi', 'nedovoljno na zalihi')
	FROM kopija k
	JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE k.dostupan = 1
    GROUP BY f.id, m.id
    ORDER BY f.naslov;

-- korištenje CASE strukture toka
SELECT f.naslov, m.tip, COUNT(k.id) AS broj_kopija, 
	CASE 
    	WHEN COUNT(k.id) = 0 THEN 'nema na zalihi'
        WHEN COUNT(k.id) <= 2 THEN 'mala zaliha'
        WHEN COUNT(k.id) > 2 THEN 'dovoljna zaliha'
        ELSE 'nemamo podatak'
    END AS STANJE
	FROM kopija k
	JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE k.dostupan = 1
    GROUP BY f.id, m.id
    ORDER BY f.naslov;

-- korištenje MAX funkcije (ima i MIN) i primjer selektiranja iz pogleda (VIEW)
SELECT 
    MAX(dostupne_kopije) AS 'najvise kopija'
    MAX(godina_filma) AS 'najnoviji film'
    FROM available_movies;

-- korištenje REPLACE funkcije
SELECT REPLACE(adresa, ' ', '_') 
    FROM clanovi;

UPDATE clanovi
    SET adresa = REPLACE(adresa, ' ', '_');

-- vremenske funkcije
SELECT
    NOW() AS trenutni_datum_vrijeme,
    CURTIME() AS trenutno_vrijeme,
    CURDATE() AS trenutni_datum,
    CURRENT_TIMESTAMP;

SELECT
    DATE_FORMAT(p.datum_posudbe, '%d.%m.%Y.') AS formatirani_datum_posudbe,
    MONTHNAME(p.datum_posudbe) AS ime_mjeseca,
    MONTH(p.datum_posudbe) AS mjesec,
    YEAR(p.datum_posudbe) AS godina,
    DATE(p.datum_posudbe) AS datum,
    TIME(p.updated_at) AS vrijeme,
    DAY(p.updated_at) AS dan,
    HOUR(p.updated_at) AS sat,
    MINUTE(p.updated_at) AS minuta,
    SECOND(p.updated_at) AS sekunda,
    DATEDIFF(p.updated_at, p.datum_posudbe) AS datum_vece_manje,
    DATEDIFF(p.datum_posudbe, p.updated_at) AS datum_manje_vece,
    DATE_ADD(p.datum_posudbe, INTERVAL 1 DAY) AS dodaj_dan,
    DATE_SUB(p.datum_posudbe, INTERVAL 1 MONTH) AS oduzmi_mjesec,
    TIMESTAMPDIFF(MINUTE, p.updated_at, NOW()) razlika_u_minutama
FROM
    posudba p;
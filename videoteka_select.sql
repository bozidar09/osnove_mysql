/* Dohvati sve (zapise i polja) podatke iz tablice filmovi */
SELECT * FROM filmovi;

/* Dohvati sve (zapise i polja) podatke iz tablice clanovi */
SELECT * FROM clanovi;

-- dohvati polja naslov, godina (kao aliase) iz tablice filmovi
SELECT naslov AS Naslov, godina as 'Godina izdanja' FROM filmovi;

-- dohvati samo prvi zapis iz tablice filmovi
SELECT * FROM filmovi WHERE 1;

-- dohvati zapis iz tablice filmovi sa točno određenim naslovom
SELECT * FROM filmovi WHERE naslov='inception';

-- dohvati zapis iz tablice filmovi gdje je id 2 ili 3 
SELECT * FROM filmovi WHERE id=2 OR id=3;
SELECT * FROM filmovi WHERE id IN (2,3);
SELECT * FROM filmovi WHERE id BETWEEN 2 AND 3;

-- dohvati zapis iz tablice clanovi gdje je ime Ivan i telefon je '5585829592'
SELECT * FROM clanovi WHERE ime='Ivan Horvant' AND telefon='5585829592';

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

-- count, avg, sum
SELECT count(id) AS "Broj filmova u bazi" FROM filmovi;
SELECT count(id) AS "Broj filmova u bazi mladjih od 1990" FROM filmovi WHERE godina > 1990;

SELECT avg(cijena) AS "Prosjek cijene" FROM cjenik;
SELECT format(avg(cijena), 2) AS "Prosjek cijene formatiran" FROM cjenik; -- druga opcija round() umjesto format, vraća int umjesto char

SELECT sum(cijena) AS "Ukupna cijena" FROM cjenik; 

-- inner join (jedan i više njih u jednoj select naredbi)
SELECT f.naslov, f.godina, z.ime AS 'zanr'
    FROM filmovi f -- alias može i bez AS
    JOIN zanrovi z ON f.zanr_id = z.id

SELECT f.naslov, f.godina, z.ime AS 'zanr', c.cijena AS 'cijena', c.zakasnina_po_danu AS 'zakasnina'
    FROM filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id
    JOIN cjenik c ON f.cjenik_id = c.id;

-- left join (uz DATEDIFF može LTRIM, CONCAT, a može i bez)
SELECT s2.ime AS 'Ime', s4.naslov AS 'Film' , s1.datum_posudbe AS 'Datum posudbe', s1.datum_povrata AS 'Datum povrata', CONCAT(DATEDIFF(s1.datum_povrata, s1.datum_posudbe)-1) AS 'Kašnjenje (dana)', CONCAT((DATEDIFF(s1.datum_povrata, s1.datum_posudbe)-1) * s5.zakasnina_po_danu + s5.cijena) AS 'Cijena'
    FROM posudba as s1 
    LEFT JOIN clanovi as s2 ON s1.clan_id = s2.id 
    LEFT JOIN zaliha as s3 ON s1.zaliha_id = s3.id
    LEFT JOIN filmovi AS s4 ON s4.id = s3.film_id
    LEFT JOIN cjenik AS s5 ON s5.id = s4.cjenik_id
    WHERE DATEDIFF(s1.datum_povrata, s1.datum_posudbe) >= 2; 
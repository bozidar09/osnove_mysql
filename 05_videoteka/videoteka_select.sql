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

-- join sa funkcijom DATEDIFF (uz nju može LTRIM, CONCAT, a može i bez)
SELECT cl.ime AS 'Ime', f.naslov AS 'Film' , p.datum_posudbe AS 'Datum posudbe', p.datum_povrata AS 'Datum povrata', CONCAT(DATEDIFF(p.datum_povrata, p.datum_posudbe)-1) AS 'Kašnjenje (dana)', CONCAT((DATEDIFF(p.datum_povrata, p.datum_posudbe)-1) * cj.zakasnina_po_danu + cj.cijena) AS 'Cijena'
    FROM posudba as p 
    JOIN clanovi as cl ON p.clan_id = cl.id 
    JOIN zaliha as z ON p.zaliha_id = z.id
    JOIN filmovi AS f ON z.film_id = f.id
    JOIN cjenik AS cj ON f.cjenik_id = cj.id
    WHERE DATEDIFF(p.datum_povrata, p.datum_posudbe) >= 2; 

-- spoji tablice posudba sa filmovi i mediji preko vezne tablice zaliha
SELECT p.datum_posudbe, p.datum_povrata, c.ime, f.naslov, m.tip
    FROM posudba p
    JOIN clanovi c ON p.clan_id = c.id
    JOIN zaliha z ON p.zaliha_id = z.id
    JOIN filmovi f ON z.film_id = f.id
    JOIN mediji m ON z.medij_id = m.id;


-- izlistaj posudbe i film naziv i medij za filmove koji nisu vraćeni
SELECT p.datum_posudbe, p.datum_povrata, c.ime, f.naslov, m.tip
    FROM posudba p
    JOIN clanovi c ON p.clan_id = c.id
    JOIN zaliha z ON p.zaliha_id = z.id
    JOIN filmovi f ON z.film_id = f.id
    JOIN mediji m ON z.medij_id = m.id
    WHERE p.datum_povrata IS NULL; -- sa NULL se uspoređuje pomoću 'IS NULL' i 'IS NOT NULL'

-- povezi sve tablice i izlistaj podatke
SELECT 
    p.datum_posudbe, 
    p.datum_povrata, 
    c.ime AS 'ime clana', 
    f.naslov, 
    m.tip AS 'medij', 
    zanrovi.ime AS 'zanr', 
    cjenik.tip_filma, 
    cjenik.zakasnina_po_danu
        FROM posudba p
        JOIN clanovi c ON p.clan_id = c.id
        JOIN zaliha z ON p.zaliha_id = z.id
        JOIN filmovi f ON z.film_id = f.id
        JOIN mediji m ON z.medij_id = m.id
        JOIN zanrovi ON f.zanr_id = zanrovi.id
        JOIN cjenik ON f.cjenik_id = cjenik.id;

-- ispiši članove koji su posudili više od jednog filma sa GROUP BY
SELECT c.id, c.ime AS 'clan', COUNT(*) AS "broj posudbi" -- može i sa COUNT(c.id) jer broji retke
    FROM posudba p
    JOIN clanovi c ON p.clan_id = c.id
    GROUP BY c.id
    HAVING COUNT(*) > 1;

-- ispišite totalnu količinu kopija dostupnih po filmu (zbroj svih medija) sa GROUP BY
SELECT f.id, f.naslov, SUM(z.kolicina) AS "kolicina" -- kod SUM() se mora navesti točno određeni stupac koji će se zbrajati
    FROM filmovi f
    JOIN zaliha z ON f.id = z.film_id
    GROUP BY f.id;

-- filtirajte gornji upit da izlista samo filmove koji imaju više od 10 kopija sa HAVING
SELECT f.id, f.naslov, SUM(z.kolicina) AS kolicina
    FROM filmovi f
    JOIN zaliha z ON f.id = z.film_id
    GROUP BY f.id
    HAVING kolicina > 10; -- možemo iskoristiti alias u HAVING, ali on ne smije biti deklariran pod navodnicima

-- sastavljanje podupita - dohvati sve filmove koji imaju količinu na Blueray-u
-- prvi upit kojim dohvaćamo Blueray sa količinom
SELECT z.film_id
    FROM zaliha z
    JOIN mediji m ON z.medij_id = m.id
    WHERE m.tip = 'Blu-Ray';
SELECT f.naslov
    FROM filmovi f
    WHERE f.id IN 
-- drugi upit gdje tražimo naslove filma
SELECT f.naslov
    FROM filmovi f
    WHERE f.id IN ()
-- sastavljen upit s podupitom koji daje željeni rezultat
SELECT z.film_id
    FROM zaliha z
    JOIN mediji m ON z.medij_id = m.id
    WHERE m.tip = 'Blu-Ray';

-- dohvati članove koi imaju ne vraćen film preko jednog dana (zakasnina)
SELECT c.*, DATEDIFF(p.datum_povrata, p.datum_posudbe) - 1 AS "zakasnina"
    FROM posudba p
    JOIN clanovi c ON c.id = p.clan_id
    WHERE DATEDIFF(p.datum_povrata, p.datum_posudbe) > 1 OR (p.datum_povrata IS NULL AND DATEDIFF(CURDATE(), p.datum_posudbe) > 1);

SELECT c.*, DATEDIFF(p.datum_povrata, p.datum_posudbe) - 1 AS "zakasnina"
    FROM posudba p
    JOIN clanovi c ON c.id = p.clan_id
    WHERE DATEDIFF(p.datum_povrata, p.datum_posudbe) > 1 OR DATEDIFF(IFNULL(p.datum_povrata, CURDATE()), p.datum_posudbe) > 1; -- drugi način sa IFNULL() funkcijom

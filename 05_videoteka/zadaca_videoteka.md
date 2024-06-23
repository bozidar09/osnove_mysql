### Baza podataka za poslovanje jedne videoteke.
- Kreirajte ER dijagram za poslovanje jedne videoteke.
- Videoteka članovima izdaje članske iskaznice te se na temelju članskog broja osoba identificira kako bi mogla posuditi filmove.
- Filmovi su složeni po žanrovima.
- Videoteka ima definiran cjenik za izdavanje hit filma, film koji nije hit te starog filma.
- Jedan film može biti na DVD-u, BlueRay-u ili VHS-u.
- Film se posđuje na rok od jednog dana I ako ga član ne vrati u navedeno vrijeme, zaračunava mu se zakasnina.

### Dopuna zadace
- Kreirajte novog korisnika u MySQL-u i dajte mu povlastice samo za bazu videoteka

```sql

-- kreiranje novog korisnika 'algebra'
CREATE USER 'algebra'@'localhost' IDENTIFIED BY 'algebra';
-- davanje svih povlastica za bazu '03_videoteka'
GRANT ALL PRIVILEGES ON '03_videoteka' TO 'algebra'@'localhost';
-- micanje svih povlastica korisniku 'algebra' 
REVOKE ALL PRIVILEGES ON '03_videoteka' FROM 'algebra'@'localhost';
-- brisanje korisnika 'algebra'
DROP USER 'algebra'@'localhost';

```


- Svaki film ima zalihu dostupnih kopija po mediju za koji je dostupan
- Svaka fizicka kopija filma ima svoj jedinstveni identifikacijski broj (serial number) kako bi se mogla pratiti

```sql

-- u tablici 'zaliha' mijenjamo stupac 'kolicina' u 'dostupno' 
ALTER TABLE 'zaliha' CHANGE 'kolicina' 'dostupno' TINYINT(1) NOT NULL;
-- dodajemo stupac 'serijski_broj' u tablicu 'zaliha' (nakon ovoga bi se u bazu morala ubaciti svaka pojedina kopija filma sa vlastitim serijskim brojem)
ALTER TABLE zaliha ADD COLUMN serijski_broj VARCHAR(15) NOT NULL UNIQUE AFTER id; 

-- stvaramo table view kako bi mogli provjeriti dostupne količine pojedinih filmova
CREATE VIEW kolicina AS
    SELECT f.id, f.naslov, m.tip, COUNT(*)
        FROM zaliha z
        JOIN film f ON f.id = z.film_id
        JOIN mediji ON m.id = z.medij_id
        WHERE z.dostupno = TRUE  -- filtriramo samo one kombinacije film-medij koji su dostupni
        GROUP BY f.id, m.tip;  -- grupiramo po filmu i tipu medija

```


- Clan od jednom moze posuditi vise od jednog filma

```sql

-- 1.način (view 'racun')

-- stvaranje računa putem table view-a kako bi dobili ispis posuđenih filmova za određenog člana i točno određeni dan
CREATE VIEW racun AS
    SELECT cl.id, cl.clanski_broj, cl.ime, f.naslov, m.tip, cj.cijena, p.datum_posudbe
        FROM posudba p
        JOIN clanovi cl ON cl.id = p.clan_id
        JOIN zaliha z ON z.id = p.zaliha_id
        JOIN mediji ON m.id = z.medij_id
        JOIN film f ON f.id = z.film_id
        JOIN cjenik cj ON cj.id = f.cjenik_id
        GROUP BY cl.id, p.datum_posudbe;

-- umjesto GROUP BY (gdje dobijemo popis svih posudbi grupiranih po članovima i danu) mogla bi se dodati WHERE klauzula sa uvjetom točno određenog člana i tekućeg dana, primjerice
        WHERE cl.id = 1 AND p.datum_posudbe = CURDATE()



-- 2.način (vezna tablica 'primjerci')

-- brisanje stranog ključa 'zaliha_id', te 'datum_povrata' iz tablice 'posudba' (u konačnici prebacujemo te atribute/stupce u veznu tablicu)
ALTER TABLE posudba DROP FOREIGN KEY posudba_ibfk_2;  -- strani ključ 'zaliha_id' koji je referenciran na zaliha(id)
ALTER TABLE posudba DROP COLUMN zaliha_id;
ALTER TABLE posudba DROP COLUMN datum_povrata;

-- stvaranje vezne tablice 'primjerci' između tablica 'posudba' i 'zaliha' 
CREATE TABLE IF NOT EXISTS primjerci (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    posudba_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (posudba_id) REFERENCES posudba(id),
    zaliha_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zaliha_id) REFERENCES zaliha(id),
    datum_povrata DATE
)ENGINE=InnoDB;

-- stvaranje okidača gdje mijenjamo status stupca 'dostupno' iz 1 u 0 u tablici 'zaliha' ako je film sa tim serijskim brojem posuđen (nalazi se u tablici primjerci i datum_povrata je NULL) 
CREATE TRIGGER insert_dostupno
    AFTER INSERT ON primjerci
    FOR EACH ROW
        WHEN (primjerci.datum_povrata IS NULL)
            (UPDATE zaliha SET dostupno = 0
                WHERE zaliha.id = primjerci.zaliha_id);

-- stvaranje okidača gdje mijenjamo status stupca 'dostupno' iz 0 u 1 u tablici 'zaliha' nakon što je film sa tim serijskim brojem vraćen (nalazi se u tablici primjerci i datum_povrata postoji, nije NULL) 
CREATE TRIGGER update_dostupno
    AFTER UPDATE ON primjerci
    FOR EACH ROW
        WHEN (primjerci.datum_povrata IS NOT NULL)
            (UPDATE zaliha SET dostupno = 1
                WHERE zaliha.id = primjerci.zaliha_id);

```
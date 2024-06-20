### Baza podataka za poslovanje jedne videoteke.
- Kreirajte ER dijagram za poslovanje jedne videoteke.
- Videoteka članovima izdaje članske iskaznice te se na temelju članskog broja osoba identificira kako bi mogla posuditi filmove.
- Filmovi su složeni po žanrovima.
- Videoteka ima definiran cjenik za izdavanje hit filma, film koji nije hit te starog filma.
- Jedan film može biti na DVD-u, BlueRay-u ili VHS-u.
- Film se posđuje na rok od jednog dana I ako ga član ne vrati u navedeno vrijeme, zaračunava mu se zakasnina.

### Dopuna zadace
- Svaki film ima zalihu dostupnih kopija po mediju za koji je dostupan
- Svaka fizicka kopija filma ima svoj jedinstveni identifikacijski broj (barcode) kako bi se mogla pratiti
- Clan od jednom moze posuditi vise od jednog filma


```sql

-- mičemo stupac kolicina iz tablice zaliha, te dodajemo barkod (nakon ovoga bi se u bazu morala ubaciti svaka pojedina kopija filma sa vlastitim barkodom)
ALTER TABLE zaliha DROP COLUMN kolicina; 
ALTER TABLE zaliha ADD COLUMN barcode VARCHAR(15) NOT NULL UNIQUE AFTER id; 

-- stvaramo table view kako bi mogli provjeriti dostupne količine pojedinih filmova
CREATE VIEW kolicina AS
    SELECT f.id, f.naslov, m.tip, COUNT(*)
        FROM zaliha z
        JOIN film f ON f.id = z.film_id
        JOIN mediji ON m.id = z.medij_id
        GROUP BY f.id, m.tip  -- grupiramo po filmu i tipu medija
        HAVING COUNT(*) > 0;  -- dodajemo da nam ispiše samo one kombinacije film-medij za koje postoje dostupne količine

-- pokušaj stvaranja računa putem table view-a kako bi dobili ispis posuđenih filmova za određenog člana i točno određeni dan
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


```

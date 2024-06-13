INSERT INTO zanr (tip)
VALUES ('science fiction'), ('comedy'), ('gangster');

INSERT INTO film (naslov, godina, zanr_id)
VALUES ('Inception'), ('The Hangover'), ('The Godfather',);

INSERT INTO medij (tip, koeficijent)
VALUES ('kazeta', 1), ('DVD', 1.2), ('Blue-Ray', 1.5);

INSERT INTO zaliha (film_id, medij_id, kolicina)
VALUES ('Inception'), ('The Hangover'), ('The Godfather',);

INSERT INTO clan (clanski_broj, ime, adresa, email, telefon)
VALUES ('Inception'), ('The Hangover'), ('The Godfather',);

INSERT INTO cjenik (tip, cijena, zakasnina)
VALUES ('Inception'), ('The Hangover'), ('The Godfather',);

INSERT INTO posudba (datum_posudba, datum_povrat, clan_id, zaliha_id, cjenik_id)
VALUES ('Inception'), ('The Hangover'), ('The Godfather',);
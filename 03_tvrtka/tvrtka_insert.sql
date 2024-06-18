INSERT INTO gradovi (ime, zip) VALUES ('Zagreb', '10000');
INSERT INTO gradovi (ime, zip) VALUES ('Split', '21000');
INSERT INTO gradovi (ime, zip) VALUES ('Pula', '52000');

INSERT INTO zaposlenici 
    (ime, adresa, poslovnica_id, grad_id)
VALUES 
    ('Ivo Ivić', 'Ulica Grada Gospića 12', 2, 1),
    ('Ana Anić', 'Kazališni Trg 2', 2, 1),
    ('Marko Markić', 'Arsenalska 78', 4, 3),
    ('Zoran Zoranić', 'Riva 32', 3, 2),
    ('Ivan Horvat', 'Bolnička cesta 66', 3, 2);


INSERT INTO poslovnice (ime, adresa, grad_id)
VALUES 
    ('Trgovina Zagreb', 'Ulica Grada Vukovara 55', 1),
    ('Trgovina Pula', 'Trg Maršala Tita 3', 3);

DELETE FROM poslovnice WHERE id = 3;

UPDATE poslovnice SET ime = 'Trgovina Split', adresa = 'Pojišanska cesta 25' WHERE id = 3;
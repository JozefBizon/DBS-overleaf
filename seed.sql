TRUNCATE TABLE
    Dochadzka,
    Watchlist,
    Listok,
    Premietanie,
    Miesto,
    Zamestnanec,
    Zakaznik,
    Film,
    Kinosala,
    Kino
RESTART IDENTITY CASCADE;

-- KINÁ
INSERT INTO Kino (nazov, adresa, kontakt)
VALUES
('Kino Lumiere', 'Spitalska 4, Bratislava', '+421902111001'),
('Cinemax Central', 'Metodova 6, Bratislava', '+421902111002'),
('Kino Hviezda', 'Namestie SNP 12, Banska Bystrica', '+421902111003'),
('Kino Mier', 'Hlavna 45, Kosice', '+421902111004'),
('Kino Europa', 'Vajanskeho 18, Zvolen', '+421902111005');

-- KINOSÁLY
INSERT INTO Kinosala (id_kino, oznacenie, kapacita)
SELECT
    k.id_kino,
    CASE s
        WHEN 1 THEN 'Velka sala'
        WHEN 2 THEN 'Mala sala'
        WHEN 3 THEN 'VIP sala'
        ELSE 'Komorna sala'
    END,
    CASE s
        WHEN 1 THEN 120
        WHEN 2 THEN 80
        WHEN 3 THEN 60
        ELSE 70
    END
FROM Kino k
CROSS JOIN generate_series(1, 4) s;

-- MIESTA
INSERT INTO Miesto (id_sala, rad, cislo_miesta, typ_miesta)
SELECT
    ks.id_sala,
    chr(64 + r),
    c,
    CASE
        WHEN r <= 2 THEN 'VIP'
        ELSE 'standard'
    END
FROM Kinosala ks
CROSS JOIN generate_series(1, 8) r
CROSS JOIN generate_series(1, 10) c;

-- FILMY
INSERT INTO Film (nazov, dlzka_minut, zaner, datum_premiery)
VALUES
('Interstellar', 169, 'Sci-fi', '2014-11-07'),
('Inception', 148, 'Sci-fi', '2010-07-16'),
('The Dark Knight', 152, 'Akcny', '2008-07-18'),
('Gladiator', 155, 'Drama', '2000-05-05'),
('The Shawshank Redemption', 142, 'Drama', '1994-09-23'),
('Fight Club', 139, 'Drama', '1999-10-15'),
('The Matrix', 136, 'Sci-fi', '1999-03-31'),
('Avatar', 162, 'Sci-fi', '2009-12-18'),
('Titanic', 195, 'Drama', '1997-12-19'),
('The Godfather', 175, 'Drama', '1972-03-24'),
('Pulp Fiction', 154, 'Kriminalny', '1994-10-14'),
('Forrest Gump', 142, 'Drama', '1994-07-06'),
('Joker', 122, 'Drama', '2019-10-04'),
('Oppenheimer', 180, 'Drama', '2023-07-21'),
('Barbie', 114, 'Komedia', '2023-07-21'),
('Dune', 155, 'Sci-fi', '2021-10-22'),
('Dune: Part Two', 166, 'Sci-fi', '2024-03-01'),
('Top Gun: Maverick', 131, 'Akcny', '2022-05-27'),
('John Wick', 101, 'Akcny', '2014-10-24'),
('The Batman', 176, 'Akcny', '2022-03-04'),
('Avengers: Endgame', 181, 'Akcny', '2019-04-26'),
('Iron Man', 126, 'Akcny', '2008-05-02'),
('Doctor Strange', 115, 'Fantasy', '2016-11-04'),
('The Lion King', 88, 'Animovany', '1994-06-24'),
('Frozen', 102, 'Animovany', '2013-11-27'),
('Toy Story', 81, 'Animovany', '1995-11-22'),
('Shrek', 90, 'Animovany', '2001-05-18'),
('The Conjuring', 112, 'Horor', '2013-07-19'),
('A Quiet Place', 90, 'Horor', '2018-04-06'),
('Parasite', 132, 'Drama', '2019-05-30');

-- ZÁKAZNÍCI
INSERT INTO Zakaznik (meno, priezvisko, email, datum_registracie)
SELECT
    meno,
    priezvisko,
    lower(meno || '.' || priezvisko || g || '@email.sk'),
    timestamp '2024-01-01 10:00:00' + (g || ' hours')::interval
FROM (
    SELECT
        g,
        (ARRAY[
            'Marek', 'Jozef', 'Peter', 'Martin', 'Tomas', 'Lukas', 'Michal', 'Adam', 'Samuel', 'Filip',
            'Anna', 'Lucia', 'Veronika', 'Katarina', 'Zuzana', 'Petra', 'Simona', 'Nina', 'Laura', 'Eva'
        ])[((g - 1) % 20) + 1] AS meno,
        (ARRAY[
            'Novak', 'Kovac', 'Varga', 'Horvath', 'Toth', 'Nagy', 'Balaz', 'Molnar', 'Szabo', 'Krajcovic',
            'Urban', 'Polak', 'Mikus', 'Bartos', 'Kollar', 'Kovacova', 'Novotna', 'Kucerova', 'Sedlakova', 'Cerna'
        ])[((g * 7 - 1) % 20) + 1] AS priezvisko
    FROM generate_series(1, 1500) g
) x;

-- ZAMESTNANCI
INSERT INTO Zamestnanec (id_kino, meno, priezvisko, email, pozicia)
SELECT
    ((g - 1) % 5) + 1,
    meno,
    priezvisko,
    lower(meno || '.' || priezvisko || g || '@kino.sk'),
    pozicia
FROM (
    SELECT
        g,
        (ARRAY[
            'Andrej', 'Milan', 'Roman', 'Patrik', 'Daniel', 'Ivana', 'Monika', 'Lenka', 'Dominika', 'Barbora'
        ])[((g - 1) % 10) + 1] AS meno,
        (ARRAY[
            'Sedlar', 'Pavlik', 'Kralik', 'Bielik', 'Simko', 'Hruska', 'Minarik', 'Hudak', 'Gal', 'Rybar'
        ])[((g * 5 - 1) % 10) + 1] AS priezvisko,
        (ARRAY[
            'pokladnik', 'technik', 'manazer', 'uvadzac'
        ])[((g - 1) % 4) + 1] AS pozicia
    FROM generate_series(1, 80) g
) x;

-- PREMIETANIA
INSERT INTO Premietanie (id_film, id_sala, cas_zaciatku, cena_zakladna)
SELECT
    ((g - 1) % 30) + 1,
    ((g - 1) % 20) + 1,
    timestamp '2026-04-01 14:00:00' + (g || ' hours')::interval,
    CASE
        WHEN g % 5 = 0 THEN 9.90
        WHEN g % 4 = 0 THEN 8.50
        WHEN g % 3 = 0 THEN 7.90
        ELSE 6.90
    END
FROM generate_series(1, 1800) g;

-- LÍSTKY
INSERT INTO Listok (id_premietanie, id_zakaznik, id_miesto, cena, stav_listka, cas_predaja)
SELECT
    p.id_premietanie,
    ((p.id_premietanie * 7 + s.rn) % 1500) + 1,
    s.id_miesto,
    p.cena_zakladna + CASE
        WHEN m.typ_miesta = 'VIP' THEN 2.00
        ELSE 0.00
    END,
    CASE
        WHEN (p.id_premietanie + s.rn) % 25 = 0 THEN 'vrateny'::stav_listka_typ
        ELSE 'platny'::stav_listka_typ
    END,
    p.cas_zaciatku - interval '3 days' + (s.rn || ' hours')::interval
FROM Premietanie p
JOIN LATERAL (
    SELECT
        mi.id_miesto,
        row_number() OVER (ORDER BY mi.id_miesto) AS rn
    FROM Miesto mi
    WHERE mi.id_sala = p.id_sala
    ORDER BY mi.id_miesto
    LIMIT (2 + (p.id_premietanie % 5))
) s ON true
JOIN Miesto m ON m.id_miesto = s.id_miesto;

-- WATCHLIST
INSERT INTO Watchlist (id_zakaznik, id_film, datum_pridania)
SELECT
    z.id_zakaznik,
    f.id_film,
    timestamp '2025-01-01 12:00:00' + ((z.id_zakaznik + f.id_film) || ' hours')::interval
FROM Zakaznik z
CROSS JOIN Film f
WHERE ((z.id_zakaznik * 31 + f.id_film * 17) % 1000) < 27
LIMIT 1200;

-- DOCHÁDZKA
INSERT INTO Dochadzka (id_zamestnanec, cas_prichodu, cas_odchodu, poznamka)
SELECT
    ((g - 1) % 80) + 1,
    timestamp '2026-04-01 08:00:00' + (g || ' days')::interval,
    timestamp '2026-04-01 16:00:00' + (g || ' days')::interval,
    CASE
        WHEN g % 20 = 0 THEN 'nadcas'
        WHEN g % 33 = 0 THEN 'skorsi odchod'
        ELSE null
    END
FROM generate_series(1, 800) g;

ANALYZE;
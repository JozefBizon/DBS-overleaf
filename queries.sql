EXPLAIN ANALYZE
SELECT
    l.id_listok,
    f.nazov AS film,
    k.nazov AS kino,
    ks.oznacenie AS sala,
    p.cas_zaciatku,
    m.rad,
    m.cislo_miesta,
    m.typ_miesta,
    l.cena,
    l.stav_listka,
    l.cas_predaja,
    SUM(l.cena) FILTER (WHERE l.stav_listka = 'platny')
        OVER (ORDER BY l.cas_predaja) AS kumulativne_utraty,
    SUM(l.cena) FILTER (WHERE l.stav_listka = 'platny')
        OVER () AS celkova_utrata,
    COUNT(*) OVER () AS pocet_listkov_celkom
FROM Listok l
JOIN Premietanie p ON p.id_premietanie = l.id_premietanie
JOIN Film f        ON f.id_film = p.id_film
JOIN Kinosala ks   ON ks.id_sala = p.id_sala
JOIN Kino k        ON k.id_kino = ks.id_kino
JOIN Miesto m      ON m.id_miesto = l.id_miesto
WHERE l.id_zakaznik = 42
  AND l.stav_listka = 'platny'
ORDER BY l.cas_predaja DESC;
--pre index
-- "  Buffers: shared hit=36 dirtied=1"
-- "Planning Time: 1.032 ms"
-- "Execution Time: 0.591 ms"

--post index
-- "  Buffers: shared hit=71 read=3"
-- "Planning Time: 2.087 ms"
-- "Execution Time: 0.271 ms"



-- Proces 2 -- Nákup lístka a kontrola obsadenosti premietania

WITH vstup AS (
    SELECT
        42::bigint AS id_zakaznik,
        1::bigint AS id_premietanie,
        40::bigint AS id_miesto
),
validacia AS (
    SELECT
        v.id_zakaznik,
        v.id_premietanie,
        v.id_miesto,
        p.cena_zakladna
    FROM vstup v
    JOIN Zakaznik z
        ON z.id_zakaznik = v.id_zakaznik
    JOIN Premietanie p
        ON p.id_premietanie = v.id_premietanie
    JOIN Miesto m
        ON m.id_miesto = v.id_miesto
       AND m.id_sala = p.id_sala
    WHERE NOT EXISTS (
        SELECT 1
        FROM Listok l
        WHERE l.id_premietanie = v.id_premietanie
          AND l.id_miesto = v.id_miesto
    )
)
INSERT INTO Listok (
    id_premietanie,
    id_zakaznik,
    id_miesto,
    cena,
    stav_listka,
    cas_predaja
)
SELECT
    id_premietanie,
    id_zakaznik,
    id_miesto,
    cena_zakladna,
    'platny',
    CURRENT_TIMESTAMP
FROM validacia
RETURNING
    id_listok,
    id_premietanie,
    id_zakaznik,
    id_miesto,
    cena,
    stav_listka,
    cas_predaja;

--pre index
-- "  Buffers: shared hit=20 dirtied=4"
-- "Planning Time: 1.356 ms"
-- "Execution Time: 6.925 ms"

--post index
-- "  Buffers: shared hit=25 dirtied=8"
-- "Planning Time: 0.800 ms"
-- "Execution Time: 0.729 ms"
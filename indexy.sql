DROP INDEX IF EXISTS idx_listok_zakaznik;
DROP INDEX IF EXISTS idx_listok_stav;
DROP INDEX IF EXISTS idx_listok_zakaznik_stav;

CREATE INDEX idx_listok_zakaznik ON Listok (id_zakaznik);

-- filtrovanie/agregacia podla stavu listka (platny / vrateny)
CREATE INDEX idx_listok_stav ON Listok (stav_listka);

-- pokryva dotazy na historiu listkov konkretneho zakaznika + stav
CREATE INDEX idx_listok_zakaznik_stav ON Listok (id_zakaznik, stav_listka);
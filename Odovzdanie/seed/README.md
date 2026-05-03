# Seed data

Seed je pripraveny ako cisty SQL skript pre PostgreSQL. Nepouzivali sme externy generator, preto sa cele naplnenie databazy da zopakovat rovnakym sposobom na kazdom stroji.

Postup:

1. V cistej databaze spustit `schema.sql`.
2. Potom spustit `seed/seed.sql`.
3. Na overenie procesov spustit `queries.sql`.

Skript najprv vycisti tabulky cez `TRUNCATE ... RESTART IDENTITY CASCADE` a potom vlozi data v poradi, ktore respektuje cudzie kluce. Na generovanie vacsieho poctu riadkov pouziva `generate_series`, pevne zoznamy hodnot, deterministicke modulo pravidla a pri listkoch vyber sedadiel cez `JOIN LATERAL`.


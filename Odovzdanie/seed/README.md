# Reprodukcia seed dat

Postup pre PostgreSQL:

1. Spustit `schema.sql` na cistej databaze.
2. Spustit `seed/seed.sql`.
3. Volitelne spustit `queries.sql` pre ukazku oboch procesov.

Seed je deterministicky a pouziva iba SQL konstrukcie PostgreSQL (`generate_series`, `ARRAY`, `JOIN LATERAL`, `TRUNCATE ... RESTART IDENTITY CASCADE`). Pri opakovanom spusteni po `schema.sql` vzniknu rovnake pocty zaznamov.

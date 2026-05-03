drop table if exists Dochadzka cascade;
drop table if exists Watchlist cascade;
drop table if exists Listok cascade;
drop table if exists Premietanie cascade;
drop table if exists Miesto cascade;
drop table if exists Zamestnanec cascade;
drop table if exists Zakaznik cascade;
drop table if exists Film cascade;
drop table if exists Kinosala cascade;
drop table if exists Kino cascade;
drop type if exists stav_listka_typ;

create type stav_listka_typ as enum ('platny', 'vrateny');

create table Kino (
    id_kino bigint generated always as identity primary key,
    nazov varchar(100) not null,
    adresa varchar(255),
    kontakt varchar(50) unique
);

create table Kinosala (
    id_sala bigint generated always as identity primary key,
    id_kino bigint not null references Kino(id_kino) on delete restrict,
    oznacenie varchar(20) not null,
    kapacita integer not null check (kapacita > 0)
);

create table Miesto (
    id_miesto bigint generated always as identity primary key,
    id_sala bigint not null references Kinosala(id_sala) on delete restrict,
    rad varchar(10) not null,
    cislo_miesta integer not null,
    typ_miesta varchar(20) not null default 'standard',
    unique (id_sala, rad, cislo_miesta)
);

create table Film (
    id_film bigint generated always as identity primary key,
    nazov varchar(100) not null,
    dlzka_minut integer check (dlzka_minut > 0),
    zaner varchar(50),
    datum_premiery date
);

create table Zamestnanec (
    id_zamestnanec bigint generated always as identity primary key,
    id_kino bigint not null references Kino(id_kino) on delete restrict,
    meno varchar(50) not null,
    priezvisko varchar(50) not null,
    email varchar(100) unique,
    pozicia varchar(50)
);

create table Premietanie (
    id_premietanie bigint generated always as identity primary key,
    id_film bigint not null references Film(id_film) on delete restrict,
    id_sala bigint not null references Kinosala(id_sala) on delete restrict,
    cas_zaciatku timestamp not null,
    cena_zakladna numeric(10,2) check (cena_zakladna > 0)
);

create table Zakaznik (
    id_zakaznik bigint generated always as identity primary key,
    meno varchar(50),
    priezvisko varchar(50),
    email varchar(100) not null unique,
    datum_registracie timestamp not null default current_timestamp
);

create table Listok (
    id_listok bigint generated always as identity primary key,
    id_premietanie bigint not null references Premietanie(id_premietanie) on delete cascade,
    id_zakaznik bigint not null references Zakaznik(id_zakaznik) on delete restrict,
    id_miesto bigint not null references Miesto(id_miesto) on delete restrict,
    cena numeric(10,2) not null check (cena > 0),
    stav_listka stav_listka_typ not null default 'platny',
    cas_predaja timestamp not null default current_timestamp,
    unique (id_premietanie, id_miesto)
);

create table Dochadzka (
    id_dochadzka bigint generated always as identity primary key,
    id_zamestnanec bigint not null references Zamestnanec(id_zamestnanec) on delete cascade,
    cas_prichodu timestamp not null,
    cas_odchodu timestamp,
    poznamka varchar(255),
    check (cas_odchodu is null or cas_odchodu >= cas_prichodu)
);

create table Watchlist (
    id_watchlist bigint generated always as identity primary key,
    id_zakaznik bigint not null references Zakaznik(id_zakaznik) on delete cascade,
    id_film bigint not null references Film(id_film) on delete restrict,
    datum_pridania timestamp not null default current_timestamp,
    unique (id_zakaznik, id_film)
);

create index idx_listok_zakaznik
on Listok (id_zakaznik);

create index idx_listok_stav
on Listok (stav_listka);

create index idx_listok_zakaznik_stav
on Listok (id_zakaznik, stav_listka);

create index idx_listok_premietanie
on Listok (id_premietanie);

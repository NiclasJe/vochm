BEGIN;
CREATE EXTENSION IF NOT EXISTS postgis;
--
-- ACTION DROP TABLE
--
DROP TABLE "recipes" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "animal_findings" (
    "id" bigserial PRIMARY KEY,
    "animalId" bigint NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "location" geometry(Point, 4326)
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "animals" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);


--
-- MIGRATION VERSION FOR vochm
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vochm', '20251119195247032', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251119195247032', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;

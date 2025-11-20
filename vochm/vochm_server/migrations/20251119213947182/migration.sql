BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "animal_findings" ALTER COLUMN "latitude" DROP NOT NULL;
ALTER TABLE "animal_findings" ALTER COLUMN "longitude" DROP NOT NULL;

--
-- MIGRATION VERSION FOR vochm
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vochm', '20251119213947182', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251119213947182', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;

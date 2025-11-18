BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recipes" (
    "id" bigserial PRIMARY KEY,
    "author" text NOT NULL,
    "text" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "ingredients" text NOT NULL
);


--
-- MIGRATION VERSION FOR vochm
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vochm', '20251118195200621', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251118195200621', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;

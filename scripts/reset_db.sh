#!/usr/bin/env bash
# ------------------------------------------------------------
# Reset av lokal PostgreSQL-databas för Serverpod-projektet.
# ------------------------------------------------------------
# Funktion:
#  - Droppar och återskapar schema "public" (default-läge)
#  - Kan istället TRUNCATE:a alla tabeller (--truncate)
#  - Kan droppa hela databasen och skapa om (--drop-db)
#  - Skapar vanliga extensions (uuid-ossp, postgis om tillgänglig)
#  - Säkerhetsfråga innan destruktiv operation (kan hoppas över med --force)
#
# Användning:
#  ./scripts/reset_db.sh [--force] [--truncate | --drop-db] [--no-extensions]
#    --force         Kör utan interaktiv bekräftelse
#    --truncate      Truncerar alla tabeller istället för att droppa schema
#    --drop-db       Droppar hela databasen och skapar om (kräver rättigheter)
#    --no-extensions Hoppar över skapande av extensions
#
# Miljövariabler (kan exporteras innan körning):
#  DB_HOST (default: localhost)
#  DB_PORT (default: 5432)
#  DB_NAME (default: vochm_test)
#  DB_USER (default: postgres)
#  DB_PASSWORD (default: postgres)
#
# Exempel:
#  DB_NAME=vochm_development ./scripts/reset_db.sh
#  ./scripts/reset_db.sh --force --truncate
#  ./scripts/reset_db.sh --force --drop-db
# ------------------------------------------------------------
set -euo pipefail

# --- Konfiguration ---
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-vochm}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-postgres}"
PSQL="psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME}"

MODE="schema"            # schema | truncate | dropdb
FORCE=false
CREATE_EXTENSIONS=true

# --- Argumentparsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE=true
      shift
      ;;
    --truncate)
      MODE="truncate"
      shift
      ;;
    --drop-db)
      MODE="dropdb"
      shift
      ;;
    --no-extensions)
      CREATE_EXTENSIONS=false
      shift
      ;;
    -h|--help)
      sed -n '1,60p' "$0"
      exit 0
      ;;
    *)
      echo "Okänt argument: $1" >&2
      exit 1
      ;;
  esac
done

# --- Kontroll av verktyg ---
if ! command -v psql >/dev/null 2>&1; then
  echo "Fel: psql saknas. Installera PostgreSQL-klient (brew install libpq && echo \"export PATH=\$(brew --prefix)/opt/libpq/bin:$PATH\" >> ~/.zshrc)." >&2
  exit 1
fi

export PGPASSWORD="$DB_PASSWORD"

echo "== Reset DB =="
echo "Host:     $DB_HOST"
echo "Port:     $DB_PORT"
echo "Database: $DB_NAME"
echo "User:     $DB_USER"
echo "Läge:     $MODE"
echo "Extensions: $CREATE_EXTENSIONS"

if [[ "$FORCE" != true ]]; then
  read -r -p "Bekräfta reset av databasen (skriv 'ja'): " ANSWER
  if [[ "$ANSWER" != "ja" ]]; then
    echo "Avbrutet."; exit 0
  fi
fi

# --- Funktioner ---
truncate_all() {
  echo "[INFO] Truncerar samtliga tabeller..."
  TABLES=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT tablename FROM pg_tables WHERE schemaname='public';") || true
  if [[ -z "$TABLES" ]]; then
    echo "[INFO] Inga tabeller att truncera."; return
  fi
  # Bygg kommaseparerad lista
  LIST=$(echo "$TABLES" | tr -s '\n' ' ' | sed 's/ $//')
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "TRUNCATE $LIST RESTART IDENTITY CASCADE;"
}

reset_schema() {
  echo "[INFO] Droppar och återskapar schema public..."
  $PSQL -c "DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO $DB_USER;"
}

drop_and_recreate_db() {
  echo "[INFO] Droppar hela databasen $DB_NAME..."
  # Anslut till postgres-systemdb för att droppa
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d postgres -c "DROP DATABASE IF EXISTS \"$DB_NAME\"; CREATE DATABASE \"$DB_NAME\";"
}

create_extensions() {
  echo "[INFO] Skapar extensions (uuid-ossp, postgis om tillgänglig)..."
  $PSQL -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";" || true
  # PostGIS är valfritt
  $PSQL -c "CREATE EXTENSION IF NOT EXISTS postgis;" || echo "[WARN] PostGIS ej installerad eller saknar rättigheter."
}

# --- Utför valt läge ---
case "$MODE" in
  truncate)
    truncate_all
    ;;
  schema)
    reset_schema
    ;;
  dropdb)
    drop_and_recreate_db
    ;;
  *)
    echo "[ERROR] Okänt läge $MODE"; exit 1
    ;;
esac

# Om vi droppade hela DB:n eller schema -> skapa extensions
if [[ "$CREATE_EXTENSIONS" == true && "$MODE" != "truncate" ]]; then
  create_extensions
fi

echo "[INFO] Reset klar."

echo "[INFO] Kör migreringar (Serverpod) om du vill nu, exempel:"
echo "       cd vochm/vochm_server && dart pub get && dart run bin/main.dart --apply-migrations --exit"


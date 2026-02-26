#!/bin/bash
set -e

echo "Enabling PostGIS extension..."
for DB in family family_dev; do
    docker exec postgres-postgis psql -U admin -d "$DB" -c "CREATE EXTENSION IF NOT EXISTS postgis;"
    docker exec postgres-postgis psql -U admin -d "$DB" -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"
done

echo "Verifying..."
for DB in family family_dev; do
    docker exec postgres-postgis psql -U admin -d "$DB" -c "SELECT PostGIS_Full_Version();"
done

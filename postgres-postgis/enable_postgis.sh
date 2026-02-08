#!/bin/bash
set -e

echo "Enabling PostGIS extension..."
docker exec postgres-postgis psql -U admin -d my_agents_db -c "CREATE EXTENSION IF NOT EXISTS postgis;"
docker exec postgres-postgis psql -U admin -d my_agents_db -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"

echo "Verifying..."
docker exec postgres-postgis psql -U admin -d my_agents_db -c "SELECT PostGIS_Full_Version();"

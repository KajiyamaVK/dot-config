#!/bin/bash
set -e

echo "=== Verifying Postgres & PostGIS Setup ==="

# 1. Check Containers
echo -n "Checking containers... "
if docker ps | grep -q "postgres-postgis" && docker ps | grep -q "pgadmin"; then
    echo "OK (Running)"
else
    echo "FAIL (Containers not running)"
    exit 1
fi

# 2. Check PostGIS Extension
echo "Checking PostGIS extension..."
docker exec postgres-postgis psql -U admin -d my_agents_db -c "SELECT PostGIS_Full_Version();"

# 3. Check Users
echo "Checking Clean Users..."
docker exec postgres-postgis psql -U admin -d my_agents_db -c "SELECT usename FROM pg_user WHERE usename IN ('system', 'kajiyamavk');"

# 4. Check Nginx Proxy (PgAdmin)
echo "Checking PgAdmin access via Nginx..."
if curl -s -I -H "Host: pg.kajiyama.com.br" http://localhost | grep -q "200 OK\|302 Found"; then
     echo "OK (PgAdmin is reachable via Nginx)"
else
     echo "WARNING: PgAdmin might not be reachable via pg.kajiyama.com.br"
     echo "Response Headers:"
     curl -s -I -H "Host: pg.kajiyama.com.br" http://localhost
fi

echo "=== Verification Complete ==="

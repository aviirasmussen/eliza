#!/bin/bash
set -e
# create minion_backend for Mojolicious integration
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"<<-EOSQL
	CREATE USER minion;
	CREATE DATABASE minion_backend;
	GRANT ALL PRIVILEGES ON DATABASE minion_backend TO minion;
EOSQL
echo "Mojolicious Minion backend database created"

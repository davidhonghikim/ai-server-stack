#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL

-- Create Databases if they don't exist
SELECT 'CREATE DATABASE kos' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'kos')\gexec
SELECT 'CREATE DATABASE n8n' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'n8n')\gexec
SELECT 'CREATE DATABASE penpot' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'penpot')\gexec
SELECT 'CREATE DATABASE gitea' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'gitea')\gexec
SELECT 'CREATE DATABASE supabase' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'supabase')\gexec

-- Create Roles (Users) if they don't exist
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'n8n') THEN
      CREATE ROLE n8n WITH LOGIN PASSWORD '${N8N_DB_PASSWORD}';
   END IF;
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'penpot') THEN
      CREATE ROLE penpot WITH LOGIN PASSWORD '${PENPOT_DB_PASSWORD}';
   END IF;
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'gitea') THEN
      CREATE ROLE gitea WITH LOGIN PASSWORD '${GITEA_DB_PASSWORD}';
   END IF;
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'supabase') THEN
      CREATE ROLE supabase WITH LOGIN PASSWORD '${SUPABASE_DB_PASSWORD}';
   END IF;
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'kosadmin') THEN
      CREATE ROLE kosadmin WITH SUPERUSER LOGIN PASSWORD '${ADMIN_PASSWORD}';
   END IF;
END
\$\$;

-- Grant ownership
ALTER DATABASE n8n OWNER TO n8n;
ALTER DATABASE penpot OWNER TO penpot;
ALTER DATABASE gitea OWNER TO gitea;
ALTER DATABASE supabase OWNER TO supabase;
ALTER DATABASE kos OWNER TO kosadmin;

EOSQL
-- Optional initialization script for PostgreSQL
-- This script can be mounted into the container for custom setup
-- Example usage: docker exec -i <container> psql -U postgres < scripts/init-db.sql

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_database WHERE datname = 'racing_leaderboards'
    ) THEN
        CREATE DATABASE racing_leaderboards;
    END IF;
END$$;

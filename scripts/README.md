# Database Initialization Scripts

This directory contains scripts and documentation for initializing and maintaining the PostgreSQL database used by the Racing Leaderboards application.

## Automatic Database Creation

The PostgreSQL container in `docker-compose.yml` uses the `POSTGRES_DB` environment variable to automatically create the `racing_leaderboards` database on first startup. No manual intervention is required for standard development and production setups.

## Manual Initialization

For more complex scenarios, use the `init-db.sql` script:

```
docker exec -i <container_name> psql -U postgres < scripts/init-db.sql
```

This script will create the `racing_leaderboards` database if it does not exist. You can extend this script to add users, permissions, or seed data as needed.

## Troubleshooting

- If the database is not created automatically, ensure the `POSTGRES_DB` variable is set in `docker-compose.yml`.
- To reset the database, remove the Docker volume:
  ```
  docker-compose down -v
  docker-compose up
  ```
- Check container logs for errors related to database creation.

## Elixir Application Configuration

Ensure your `DATABASE_URL` in `.env` matches the database name set by `POSTGRES_DB`. Example:

```
DATABASE_URL=ecto://postgres:postgres@localhost:5432/racing_leaderboards
```

Refer to the main README for more details on application setup.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Racing Leaderboards is a Phoenix LiveView application for tracking racing game records and leaderboards. It manages users, games, circuits, cars, and time records with support for daily/weekly challenges.

## Development Commands

### Setup and Dependencies
```bash
mix setup                    # Install dependencies, setup database, build assets
mix deps.get                 # Install Elixir dependencies
```

### Database Management
```bash
mix ecto.create              # Create database
mix ecto.migrate             # Run migrations
mix ecto.reset               # Drop, create, and migrate database
mix ecto.setup               # Create, migrate, and seed database
```

### Running the Application
```bash
mix phx.server               # Start Phoenix server (http://localhost:4000)
iex -S mix phx.server        # Start with interactive Elixir shell
```

### Asset Management
```bash
mix assets.setup             # Install Tailwind and esbuild if missing
mix assets.build             # Build assets for development
mix assets.deploy            # Build and minify assets for production
```

### Testing
```bash
mix test                     # Run all tests (creates test DB automatically)
mix test test/path/to/file   # Run specific test file
```

### Docker Development
```bash
docker compose up --build    # Build and run application with PostgreSQL
./update.sh                  # Update deployment (git pull + docker rebuild)
```

## Architecture Overview

### Domain Contexts
The application follows Phoenix contexts pattern with five main domains:

- **Users** (`RacingLeaderboards.Users`) - User management
- **Games** (`RacingLeaderboards.Games`) - Racing game definitions
- **Circuits** (`RacingLeaderboards.Circuits`) - Track/course management
- **Cars** (`RacingLeaderboards.Cars`) - Vehicle management  
- **Records** (`RacingLeaderboards.Records`) - Time records and leaderboards

### Data Relationships
```
Game (has many) -> Circuits, Cars, Records
Record (belongs to) -> User, Game, Circuit, Car
```

### Key Schema Details
- **Records** use `:time_usec` type for precise timing with automatic "00:" prefix handling for mm:ss format
- **Games** use unique `code` field as URL parameter (e.g., "/games/dirt-rally-2.0")
- All timestamps use `:utc_datetime` type
- Records support DNF (Did Not Finish) and verification flags

### LiveView Structure
Each domain has full CRUD LiveViews following Phoenix conventions:
- `Index` - List view with inline new/edit modals
- `Show` - Detail view with inline edit modal  
- `FormComponent` - Shared form component for new/edit

### Special Features
- **Time Records by Date/Week**: Dedicated controllers for viewing records by specific dates or weeks
- **Daily/Weekly Challenges**: Special endpoints for current daily and weekly challenges
- **Nested Routes**: Games contain circuits, cars, and records (e.g., `/games/:game_code/circuits`)

### Database Seeding
The application includes extensive seed data for games like Dirt Rally 2.0 and WRC 24, populated via migrations in `priv/repo/migrations/`.

### Asset Pipeline
- **Tailwind CSS** for styling
- **esbuild** for JavaScript bundling
- Static assets served from `priv/static/`
- Game logos and thumbnails stored in `priv/static/images/`

### Testing Setup
- Uses ExUnit with Ecto SQL Sandbox for database isolation
- Fixtures available for all domains in `test/support/fixtures/`
- Both DataCase and ConnCase available for different test types

### Deployment
- Dockerized with multi-stage build
- PostgreSQL database
- Production-ready with release configuration
- Environment variables in `.env` file (see `.env.example`)

## Development Notes

### Time Format Handling
Records automatically prepend "00:" to times in "mm:ss" format to create valid "hh:mm:ss" format. This is handled in `Record.changeset/2` at lib/racing_leaderboards/records/record.ex:20-35.

### URL Patterns
Game-specific routes use `game_code` parameter (e.g., "dirt-rally-2.0") rather than numeric IDs for better SEO and user experience.

### Component Architecture
Extended core components are available in `RacingLeaderboardsWeb.ExtendedCoreComponents` in addition to standard Phoenix components.

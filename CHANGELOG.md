# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.2.0] - 2024-07-18

### Added
- **Weekly Stats Page**: New page showing fastest driver by game+circuit+car combination for entire week
  - Route: `/games/:game_code/stats/weekly/:date`
  - Displays fastest driver for each circuit+car combination during the specified week
  - Shows all entries for each combination with time differentials
  - Reuses existing UI components (`record_by_date_overview`, `grouped_records`)
  - Proper error handling for edge cases (no records, DNF-only records)
- **Navigation Links**: Added weekly stats navigation links to home page and game show pages
- **Data Generation Tools**: Complete testing infrastructure for generating realistic race data
  - Migration for 10 fake users with realistic names
  - Command-line script for generating race records with realistic timing patterns
  - SQL script version for database initialization

### Technical Implementation
- Added `get_fastest_records_by_game_week_combinations/2` function to Records context
- Added `weekly_stats/2` action to RecordsForGameController
- Added `parse_week_range/1` function to DateUtils module
- Created `weekly_stats.html.heex` template
- Enhanced navigation with weekly stats links in home and game show pages
- Added unique constraint to user names for data integrity
- Comprehensive test coverage for new functionality
- Fixed Elixir version compatibility in mix.exs

### Files Modified
- `lib/racing_leaderboards_web/router.ex` - Added new route
- `lib/racing_leaderboards/records.ex` - Added new query function
- `lib/racing_leaderboards_web/controllers/records_for_game_controller.ex` - Added controller action
- `lib/racing_leaderboards_web/components/date_utils.ex` - Added date utility function
- `lib/racing_leaderboards_web/controllers/page_html/home.html.heex` - Added weekly stats navigation link
- `lib/racing_leaderboards_web/live/game_live/show.ex` - Added date assign for navigation
- `lib/racing_leaderboards_web/live/game_live/show.html.heex` - Added weekly stats navigation link
- `lib/racing_leaderboards/users/user.ex` - Added unique constraint for user names
- `mix.exs` - Fixed Elixir version compatibility

### Files Created
- `lib/racing_leaderboards_web/controllers/records_for_game_html/weekly_stats.html.heex` - New template
- `test/racing_leaderboards_web/controllers/records_for_game_controller_test.exs` - Controller tests
- `priv/repo/migrations/20250719041657_add_fake_users.exs` - Migration for test users
- `generate_data.exs` - Command-line data generation script
- `scripts/add_fake_users.sql` - SQL script for adding test users
- Enhanced `test/racing_leaderboards/records_test.exs` - Added tests for new Records function
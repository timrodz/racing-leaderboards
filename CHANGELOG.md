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

### Technical Implementation
- Added `get_fastest_records_by_game_week_combinations/2` function to Records context
- Added `weekly_stats/2` action to RecordsForGameController
- Added `parse_week_range/1` function to DateUtils module
- Created `weekly_stats.html.heex` template
- Comprehensive test coverage for new functionality
- Fixed Elixir version compatibility in mix.exs

### Files Modified
- `lib/racing_leaderboards_web/router.ex` - Added new route
- `lib/racing_leaderboards/records.ex` - Added new query function
- `lib/racing_leaderboards_web/controllers/records_for_game_controller.ex` - Added controller action
- `lib/racing_leaderboards_web/components/date_utils.ex` - Added date utility function
- `mix.exs` - Fixed Elixir version compatibility

### Files Created
- `lib/racing_leaderboards_web/controllers/records_for_game_html/weekly_stats.html.heex` - New template
- `test/racing_leaderboards_web/controllers/records_for_game_controller_test.exs` - Controller tests
- Enhanced `test/racing_leaderboards/records_test.exs` - Added tests for new Records function
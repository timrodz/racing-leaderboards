# Data Generation Script for Racing Leaderboards
# Usage: mix run generate_data.exs --game=<name> --car=<name or code> --start=2024-01-01 --end=2024-01-31 [--circuit=<name>]
# Example for Dirt Rally 2.0: mix run scripts/generate_data.exs --game="dirt-rally-2.0" --car="Subaru Impreza" --start=2024-01-01 --end=2024-01-31
# Example for WRC: mix run scripts/generate_data.exs --game="wrc-24" --car="SUBARU Impreza 1995" --start=2024-01-01 --end=2024-01-31 --circuit="La Bollène-Vésubie - Col de Turini"

defmodule RacingLeaderboards.DataGenerator do
  alias RacingLeaderboards.{Games, Cars, Circuits, Users, Records}

  def run(args) do
    parsed_args = parse_args(args)

    case validate_args(parsed_args) do
      {:ok, config} ->
        generate_records(config)
        IO.puts("Task successful")

      {:error, message} ->
        IO.puts("Error: #{message}")
        print_usage()
    end
  end

  defp parse_args(args) do
    {parsed, _, _} =
      OptionParser.parse(args,
        strict: [
          game: :string,
          car: :string,
          circuit: :string,
          start: :string,
          end: :string
        ]
      )

    parsed
  end

  defp validate_args(args) do
    with {:ok, game_name} <- get_required_arg(args, :game, "Game name is required"),
         {:ok, car_name} <- get_required_arg(args, :car, "Car name is required"),
         {:ok, start_date} <- parse_date(args[:start], "Start date is required (YYYY-MM-DD)"),
         {:ok, end_date} <- parse_date(args[:end], "End date is required (YYYY-MM-DD)"),
         {:ok, game} <- find_game(game_name),
         {:ok, car} <- find_car(car_name, game.id),
         {:ok, circuits} <- get_circuits(args[:circuit], game.id),
         {:ok, users} <- get_users() do
      {:ok,
       %{
         game: game,
         car: car,
         circuits: circuits,
         users: users,
         start_date: start_date,
         end_date: end_date,
         single_circuit: args[:circuit] != nil
       }}
    else
      error -> error
    end
  end

  defp get_required_arg(args, key, error_msg) do
    case args[key] do
      nil -> {:error, error_msg}
      value -> {:ok, value}
    end
  end

  defp parse_date(date_string, error_msg) do
    case date_string do
      nil ->
        {:error, error_msg}

      date_str ->
        case Date.from_iso8601(date_str) do
          {:ok, date} -> {:ok, date}
          {:error, _} -> {:error, "Invalid date format: #{date_str}. Use YYYY-MM-DD"}
        end
    end
  end

  defp find_game(game_name) do
    case Games.list_games()
         |> Enum.find(
           &(String.downcase(&1.name) == String.downcase(game_name) or
               String.downcase(&1.code) == String.downcase(game_name))
         ) do
      nil -> {:error, "Game not found: #{game_name}"}
      game -> {:ok, game}
    end
  end

  defp find_car(car_name, game_id) do
    cars = Cars.list_cars_by_game(game_id)

    case Enum.find(cars, &(String.downcase(&1.name) == String.downcase(car_name))) do
      nil -> {:error, "Car not found: #{car_name}"}
      car -> {:ok, car}
    end
  end

  defp get_circuits(circuit_name, game_id) do
    all_circuits = Circuits.list_circuits_by_game(game_id)

    case circuit_name do
      nil ->
        # Return all circuits for rotation
        {:ok, all_circuits}

      name ->
        # Find specific circuit
        case Enum.find(all_circuits, &(String.downcase(&1.name) == String.downcase(name))) do
          nil -> {:error, "Circuit not found: #{name}"}
          circuit -> {:ok, [circuit]}
        end
    end
  end

  defp get_users do
    users = Users.list_users()

    if length(users) < 10 do
      {:error, "Need at least 10 users in database. Run migration first: mix ecto.migrate"}
    else
      {:ok, Enum.take(users, 10)}
    end
  end

  defp generate_records(config) do
    # Assign skill levels to users (4:00 to 6:00 minutes base time)
    base_times = assign_skill_levels(config.users)

    # Generate date range
    dates =
      Date.range(config.start_date, config.end_date)
      |> Enum.to_list()

    # Generate records for each date
    Enum.each(dates, fn date ->
      circuit = get_circuit_for_date(config.circuits, date, config.single_circuit)

      generated_records =
        generate_records_for_date(date, circuit, config.car, base_times, config.game.id)

      IO.puts(
        "Generated #{length(generated_records)} records for #{date} on circuit #{circuit.name} with car #{config.car.name}"
      )
    end)
  end

  defp assign_skill_levels(users) do
    # Base times from 4:00 to 6:00 minutes (240 to 360 seconds)
    users
    |> Enum.with_index()
    |> Enum.map(fn {user, index} ->
      # Distribute skill levels evenly across the range
      base_seconds = (240 + index * 120 / 9) |> round()
      {user, base_seconds}
    end)
    |> Map.new()
  end

  defp get_circuit_for_date(circuits, date, single_circuit) do
    if single_circuit do
      hd(circuits)
    else
      # Use date as seed for consistent randomness per date
      {year, _month, day} = Date.to_erl(date)
      :rand.seed(:exsss, {Date.day_of_year(date), year, day})
      Enum.random(circuits)
    end
  end

  defp generate_records_for_date(date, circuit, car, base_times, game_id) do
    # 10% chance of DNF per user per day (roughly 1 DNF per 10 records)
    dnf_threshold = 0.1

    Enum.map(base_times, fn {user, base_seconds} ->
      # ±10 seconds variation for each record
      # -10 to +10 seconds
      variation = :rand.uniform(21) - 11
      final_seconds = base_seconds + variation

      # Convert to Time format (HH:MM:SS)
      hours = div(final_seconds, 3600)
      minutes = div(rem(final_seconds, 3600), 60)
      seconds = rem(final_seconds, 60)

      time = Time.new!(hours, minutes, seconds)
      is_dnf = :rand.uniform() < dnf_threshold

      # Create the record
      Records.create_record(%{
        game_id: game_id,
        circuit_id: circuit.id,
        car_id: car.id,
        user_id: user.id,
        date: date,
        time: time,
        is_dnf: is_dnf,
        is_verified: true
      })
    end)
  end

  defp print_usage do
    IO.puts("""
    Usage: mix run generate_data.exs --game=<game_name> --car=<car_name> --start=2024-01-01 --end=2024-01-31 [--circuit=<circuit_name>]

    Required arguments:
      --game      Name of the game (case insensitive)
      --car       Name of the car (case insensitive)
      --start     Start date (YYYY-MM-DD format)
      --end       End date (YYYY-MM-DD format)

    Optional arguments:
      --circuit   Specific circuit name (if not provided, circuits will be randomized)

    Examples:
      mix run generate_data.exs --game="Dirt Rally 2.0" --car="Subaru Impreza" --start=2024-01-01 --end=2024-01-31
      mix run generate_data.exs --game="Dirt Rally 2.0" --car="Subaru Impreza" --circuit="Monte Carlo" --start=2024-01-01 --end=2024-01-07
    """)
  end
end

RacingLeaderboards.DataGenerator.run(System.argv())

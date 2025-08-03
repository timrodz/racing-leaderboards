defmodule RacingLeaderboards.Records do
  @moduledoc """
  The Records context.
  """

  import Ecto.Query, warn: false
  alias RacingLeaderboards.Repo

  alias RacingLeaderboards.Records.Record

  @doc """
  Returns the list of records.

  ## Examples

      iex> list_records()
      [%Record{}, ...]

  """
  def list_records do
    Repo.all(from(Record, order_by: [desc: :date]))
    |> Repo.preload([:user, :circuit, :car])
  end

  def list_records(%{limit: limit}) do
    Repo.all(from Record, limit: ^limit, order_by: [asc: :date])
    |> Repo.preload([:user, :circuit, :car])
  end

  def list_daily_records(%{limit: limit}) do
    date = NaiveDateTime.local_now()

    Repo.all(
      from(r in Record,
        where:
          r.date >= ^NaiveDateTime.beginning_of_day(date) and
            r.date <= ^NaiveDateTime.end_of_day(date),
        limit: ^limit,
        order_by: [asc: :date]
      )
    )
    |> Repo.preload([:user, :circuit, :car])
  end

  def list_records_by_date(date) do
    Repo.all(
      from(r in Record,
        where: r.date == ^date,
        order_by: [asc: :is_dnf, asc: :time]
      )
    )
    |> Repo.preload([:user, :circuit, :car])
  end

  def list_records_by_week(date_string) do
    date =
      case Date.from_iso8601(date_string) do
        {:ok, parsed_date} -> parsed_date
        _ -> NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      end

    Repo.all(
      from(r in Record,
        where:
          r.date >= ^Date.beginning_of_week(date) and
            r.date <= ^Date.end_of_week(date),
        order_by: [asc: :date, asc: :is_dnf, asc: :time]
      )
    )
    |> Repo.preload([:user, :circuit, :car])
  end

  def list_records_by_game_date(game_id, date) do
    Repo.all(
      from(r in Record,
        where: r.game_id == ^game_id and r.date == ^date,
        order_by: [asc: :is_dnf, asc: :time]
      )
    )
    |> Repo.preload([:user, :circuit, :car])
  end

  def list_records_by_game_week(game_id, date_string) do
    date =
      case Date.from_iso8601(date_string) do
        {:ok, parsed_date} -> parsed_date
        _ -> NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      end

    Repo.all(
      from(r in Record,
        where:
          r.game_id == ^game_id and
            r.date >= ^Date.beginning_of_week(date) and
            r.date <= ^Date.end_of_week(date),
        order_by: [asc: :date, asc: :is_dnf, asc: :time]
      )
    )
    |> Repo.preload([:user, :circuit, :car])
  end

  def get_fastest_records_by_game_week_combinations(game_id, date_string) do
    records = list_records_by_game_week(game_id, date_string)
    
    records
    |> Enum.group_by(fn record -> {record.circuit_id, record.car_id} end)
    |> Enum.map(fn {{_circuit_id, _car_id}, combination_records} ->
      circuit = combination_records |> hd() |> Map.get(:circuit)
      car = combination_records |> hd() |> Map.get(:car)
      
      fastest_record = 
        combination_records
        |> Enum.reject(& &1.is_dnf)
        |> case do
          [] -> nil
          non_dnf_records -> Enum.min_by(non_dnf_records, & &1.time, Time)
        end
      
      {circuit, car, fastest_record, combination_records}
    end)
    |> Enum.sort_by(fn {circuit, car, _, _} -> {circuit.name, car.name} end)
  end

  @doc """
  Gets a single record.

  Raises `Ecto.NoResultsError` if the Record does not exist.

  ## Examples

      iex> get_record!(123)
      %Record{}

      iex> get_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_record!(id), do: Repo.get!(Record, id) |> Repo.preload(:user)

  @doc """
  Creates a record.

  ## Examples

      iex> create_record(%{field: value})
      {:ok, %Record{}}

      iex> create_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_record(attrs \\ %{}) do
    %Record{}
    |> Record.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a record.

  ## Examples

      iex> update_record(record, %{field: new_value})
      {:ok, %Record{}}

      iex> update_record(record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_record(%Record{} = record, attrs) do
    record
    |> Record.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a record.

  ## Examples

      iex> delete_record(record)
      {:ok, %Record{}}

      iex> delete_record(record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_record(%Record{} = record) do
    Repo.delete(record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking record changes.

  ## Examples

      iex> change_record(record)
      %Ecto.Changeset{data: %Record{}}

  """
  def change_record(%Record{} = record, attrs \\ %{}) do
    Record.changeset(record, attrs)
  end
end

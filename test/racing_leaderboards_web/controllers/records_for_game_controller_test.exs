defmodule RacingLeaderboardsWeb.RecordsForGameControllerTest do
  use RacingLeaderboardsWeb.ConnCase

  import RacingLeaderboards.GamesFixtures
  import RacingLeaderboards.CircuitsFixtures
  import RacingLeaderboards.CarsFixtures
  import RacingLeaderboards.UsersFixtures
  import RacingLeaderboards.RecordsFixtures

  setup do
    game = game_fixture(%{code: "test-game"})
    circuit = circuit_fixture(%{game_id: game.id})
    car = car_fixture(%{game_id: game.id})
    user = user_fixture()
    
    %{game: game, circuit: circuit, car: car, user: user}
  end

  describe "weekly_stats" do
    test "renders weekly stats with fastest driver", %{conn: conn, game: game, circuit: circuit, car: car, user: user} do
      # Create records for the same week
      date = ~D[2024-11-07]
      
      # Create a fast record
      fast_record = record_fixture(%{
        game_id: game.id,
        circuit_id: circuit.id,
        car_id: car.id,
        user_id: user.id,
        date: date,
        time: ~T[01:30:00],
        is_dnf: false
      })
      
      # Create a slower record
      user2 = user_fixture(%{name: "Slower Driver"})
      slow_record = record_fixture(%{
        game_id: game.id,
        circuit_id: circuit.id,
        car_id: car.id,
        user_id: user2.id,
        date: date,
        time: ~T[01:45:00],
        is_dnf: false
      })

      conn = get(conn, ~p"/games/#{game.code}/stats/weekly/#{date}")
      
      assert html_response(conn, 200) =~ "Weekly Stats"
      assert html_response(conn, 200) =~ game.name
      assert html_response(conn, 200) =~ "Fastest Driver This Week"
      assert html_response(conn, 200) =~ user.name
    end

    test "handles combinations with only DNF records", %{conn: conn, game: game, circuit: circuit, car: car, user: user} do
      date = ~D[2024-11-07]
      
      # Create only DNF records
      dnf_record = record_fixture(%{
        game_id: game.id,
        circuit_id: circuit.id,
        car_id: car.id,
        user_id: user.id,
        date: date,
        time: ~T[01:30:00],
        is_dnf: true
      })

      conn = get(conn, ~p"/games/#{game.code}/stats/weekly/#{date}")
      
      assert html_response(conn, 200) =~ "Weekly Stats"
      assert html_response(conn, 200) =~ game.name
      # Should not show fastest driver section since all records are DNF
      refute html_response(conn, 200) =~ "Fastest Driver This Week"
    end

    test "handles week with no records", %{conn: conn, game: game} do
      date = ~D[2024-11-07]

      conn = get(conn, ~p"/games/#{game.code}/stats/weekly/#{date}")
      
      assert html_response(conn, 200) =~ "Weekly Stats"
      assert html_response(conn, 200) =~ game.name
      # Should render empty page without errors
    end

    test "handles multiple circuit/car combinations", %{conn: conn, game: game, circuit: circuit, car: car, user: user} do
      date = ~D[2024-11-07]
      
      # Create second circuit and car
      circuit2 = circuit_fixture(%{game_id: game.id, name: "Circuit 2"})
      car2 = car_fixture(%{game_id: game.id, name: "Car 2"})
      
      # Create records for first combination
      record1 = record_fixture(%{
        game_id: game.id,
        circuit_id: circuit.id,
        car_id: car.id,
        user_id: user.id,
        date: date,
        time: ~T[01:30:00],
        is_dnf: false
      })
      
      # Create records for second combination
      record2 = record_fixture(%{
        game_id: game.id,
        circuit_id: circuit2.id,
        car_id: car2.id,
        user_id: user.id,
        date: date,
        time: ~T[01:25:00],
        is_dnf: false
      })

      conn = get(conn, ~p"/games/#{game.code}/stats/weekly/#{date}")
      
      response = html_response(conn, 200)
      assert response =~ "Weekly Stats"
      assert response =~ circuit.name
      assert response =~ circuit2.name
      assert response =~ car.name
      assert response =~ car2.name
    end
  end
end
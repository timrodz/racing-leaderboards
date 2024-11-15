defmodule RacingLeaderboards.Repo.Migrations.PopulateDirtRally2 do
  use Ecto.Migration

  import Ecto.Query
  import Ecto.Multi

  alias RacingLeaderboards.Cars.Car
  alias RacingLeaderboards.Games
  alias RacingLeaderboards.Circuits.Circuit
  alias RacingLeaderboards.Repo

  def up do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    game = Games.get_game_by_code!("dirt-rally-2.0")

    cars_raw = [
      {"Mini Cooper S", "Rally", "H1 (FWD)"},
      {"Lancia Fulvia HF", "Rally", "H1 (FWD)"},
      {"DS Automobiles DS 21", "Rally", "H1 (FWD)"},
      {"Volkswagen Golf GTI 16v", "Rally", "H2 (FWD)"},
      {"Peugeot 205 GTI", "Rally", "H2 (FWD)"},
      {"Ford Escort Mk II", "Rally", "H2 (RWD)"},
      {"Alpine Renault A110 1600 S", "Rally", "H2 (RWD)"},
      {"Fiat 131 Abarth", "Rally", "H2 (RWD)"},
      {"Opel Kadett C GT/E", "Rally", "H2 (RWD)"},
      {"BMW E30 M3 Evo Rally", "Rally", "H3 (RWD)"},
      {"Opel Ascona 400", "Rally", "H3 (RWD)"},
      {"Lancia Stratos", "Rally", "H3 (RWD)"},
      {"Renault 5 Turbo", "Rally", "H3 (RWD)"},
      {"Datsun 240Z", "Rally", "H3 (RWD)"},
      {"Ford Sierra Cosworth RS500", "Rally", "H3 (RWD)"},
      {"Lancia 037 Evo 2", "Rally", "GROUP B (RWD)"},
      {"Opel Manta 400", "Rally", "GROUP B (RWD)"},
      {"BMW M1 Procar", "Rally", "GROUP B (RWD)"},
      {"Porsche 911 SC RS", "Rally", "GROUP B (RWD)"},
      {"Audi Sport quattro S1 E2", "Rally", "GROUP B (4WD)"},
      {"Peugeot 205 T16 Evo 2", "Rally", "GROUP B (4WD)"},
      {"Lancia Delta S4", "Rally", "GROUP B (4WD)"},
      {"Ford RS200", "Rally", "GROUP B (4WD)"},
      {"MG Metro 6R4", "Rally", "GROUP B (4WD)"},
      {"Ford Fiesta R2", "Rally", "R2"},
      {"Opel Adam R2", "Rally", "R2"},
      {"Peugeot 208 R2", "Rally", "R2"},
      {"Peugeot 306 Maxi", "Rally", "F2 KIT CAR"},
      {"SEAT Ibiza Kitcar", "Rally", "F2 KIT CAR"},
      {"Volkswagen Golf Kitcar", "Rally", "F2 KIT CAR"},
      {"Mitsubishi Lancer Evolution VI", "Rally", "GROUP A"},
      {"Subaru Impreza 1995", "Rally", "GROUP A"},
      {"Lancia Delta HF Integrale", "Rally", "GROUP A"},
      {"Ford Escort RS Cosworth", "Rally", "GROUP A"},
      {"Subaru Legacy RS", "Rally", "GROUP A"},
      {"Subaru WRX STI NR4", "Rally", "NR4/R4"},
      {"Mitsubishi Lancer Evolution X", "Rally", "NR4/R4"},
      {"Ford Focus RS Rally 2001", "Rally", "UP TO 2000CC"},
      {"Subaru Impreza (2001)", "Rally", "UP TO 2000CC"},
      {"Citroën C4 Rally", "Rally", "UP TO 2000CC"},
      {"Škoda Fabia Rally 2005", "Rally", "UP TO 2000CC"},
      {"Ford Focus RS Rally 2007", "Rally", "UP TO 2000CC"},
      {"Subaru Impreza", "Rally", "UP TO 2000CC"},
      {"Peugeot 206 Rally", "Rally", "UP TO 2000CC"},
      {"Subaru Impreza S4 Rally", "Rally", "UP TO 2000CC"},
      {"Ford Fiesta R5", "Rally", "R5"},
      {"Ford Fiesta R5 MKII", "Rally", "R5"},
      {"Peugeot 208 R5 T16", "Rally", "R5"},
      {"Mitsubishi Space Star R5", "Rally", "R5"},
      {"ŠKODA Fabia R5", "Rally", "R5"},
      {"Citroën C3 R5", "Rally", "R5"},
      {"Volkswagen Polo GTI R5", "Rally", "R5"},
      {"Chevrolet Camaro GT4-R", "Rally", "RALLY GT"},
      {"Porsche 911 RGT Rally Spec", "Rally", "RALLY GT"},
      {"Aston Martin V8 Vantage GT4", "Rally", "RALLY GT"},
      {"Ford Mustang GT4", "Rally", "RALLY GT"},
      {"BMW M2 Competition", "Rally", "RALLY GT"},
      {"Volkswagen Polo S1600", "Rallycross", "RX SUPER 1600S"},
      {"Renault Clio R.S. S1600", "Rallycross", "RX SUPER 1600S"},
      {"Opel Corsa Super 1600", "Rallycross", "RX SUPER 1600S"},
      {"Speedcar Xtrem", "Rallycross", "CROSSKART"},
      {"Lancia Delta S4 Rallycross", "Rallycross", "GROUP B (RALLYCROSS)"},
      {"Ford RS200 Evolution", "Rallycross", "GROUP B (RALLYCROSS)"},
      {"Peugeot 205 T16 Rallycross", "Rallycross", "GROUP B (RALLYCROSS)"},
      {"MG Metro 6R4 Rallycross", "Rallycross", "GROUP B (RALLYCROSS)"},
      {"Ford Fiesta OMSE SuperCar Lite", "Rallycross", "RX2"},
      {"Subaru WRX STI RX", "Rallycross", "RX SUPERCARS"},
      {"Peugeot 208 WRX", "Rallycross", "RX SUPERCARS"},
      {"Audi S1 EKS RX quattro", "Rallycross", "RX SUPERCARS"},
      {"Ford Fiesta Rallycross (Mk8)", "Rallycross", "RX SUPERCARS"},
      {"Renault Megane RS RX", "Rallycross", "RX SUPERCARS"},
      {"Volkswagen Polo R Supercar", "Rallycross", "RX SUPERCARS"},
      {"Ford Fiesta Rallycross (Mk7)", "Rallycross", "RX SUPERCARS"},
      {"Renault Clio R.S. RX", "Rallycross", "RX SUPERCARS 2019"},
      {"Renault Megane RS RX", "Rallycross", "RX SUPERCARS 2019"},
      {"Ford Fiesta Rallycross (Mk8)", "Rallycross", "RX SUPERCARS 2019"},
      {"Mini Cooper SX1", "Rallycross", "RX SUPERCARS 2019"},
      {"Peugeot 208 WRX", "Rallycross", "RX SUPERCARS 2019"},
      {"Ford Fiesta Rallycross (STARD)", "Rallycross", "RX SUPERCARS 2019"},
      {"Ford Fiesta RXS Evo 5", "Rallycross", "RX SUPERCARS 2019"},
      {"Audi S1 EKS RX quattro", "Rallycross", "RX SUPERCARS 2019"},
      {"Seat Ibiza RX", "Rallycross", "RX SUPERCARS 2019"}
    ]

    circuits_raw = [
      {"Argentina", "Catamarca Province", "Las Juntas", "8.25"},
      {"Argentina", "Catamarca Province", "Valle de los puentes", "7.98"},
      {"Argentina", "Catamarca Province", "Camino de acantilados y rocas", "5.3"},
      {"Argentina", "Catamarca Province", "San Isidro", "4.48"},
      {"Argentina", "Catamarca Province", "Miraflores", "3.35"},
      {"Argentina", "Catamarca Province", "El Rodeo", "2.84"},
      {"Argentina", "Catamarca Province", "Camino a La Puerta", "8.25"},
      {"Argentina", "Catamarca Province", "Valle de los puentes a la inversa", "7.98"},
      {"Argentina", "Catamarca Province", "Camino de acantilados y rocas inverso", "5.3"},
      {"Argentina", "Catamarca Province", "Camino a Coneta", "4.48"},
      {"Argentina", "Catamarca Province", "Huillaprima", "3.35"},
      {"Argentina", "Catamarca Province", "La Merced", "2.84"},
      {"Australia", "Monaro", "Mount Kaye Pass", "12.5"},
      {"Australia", "Monaro", "Chandlers Creek", "12.34"},
      {"Australia", "Monaro", "Bondi Forest", "7.01"},
      {"Australia", "Monaro", "Rockton Plains", "6.89"},
      {"Australia", "Monaro", "Yambulla Mountain Ascent", "6.64"},
      {"Australia", "Monaro", "Noorinbee Ridge Ascent", "5.28"},
      {"Australia", "Monaro", "Mount Kaye Pass Reverse", "12.5"},
      {"Australia", "Monaro", "Chandlers Creek Reverse", "12.34"},
      {"Australia", "Monaro", "Taylor Farm Sprint", "7.01"},
      {"Australia", "Monaro", "Rockton Plains Reverse", "6.89"},
      {"Australia", "Monaro", "Yambulla Mountain Descent", "6.64"},
      {"Australia", "Monaro", "Noorinbee Ridge Descent", "5.28"},
      {"New Zealand", "Hawkes Bay", "Waimarama Point Forward", "16.06"},
      {"New Zealand", "Hawkes Bay", "Te Awanga Forward", "11.48"},
      {"New Zealand", "Hawkes Bay", "Waimarama Sprint Forward", "8.81"},
      {"New Zealand", "Hawkes Bay", "Elsthorpe Sprint Forward", "7.32"},
      {"New Zealand", "Hawkes Bay", "Ocean Beach Sprint Forward", "6.61"},
      {"New Zealand", "Hawkes Bay", "Te Awanga Sprint Forward", "4.79"},
      {"New Zealand", "Hawkes Bay", "Waimarama Point Reverse", "16.06"},
      {"New Zealand", "Hawkes Bay", "Ocean Beach", "11.48"},
      {"New Zealand", "Hawkes Bay", "Waimarama Sprint Reverse", "8.81"},
      {"New Zealand", "Hawkes Bay", "Elsthorpe Sprint Reverse", "7.32"},
      {"New Zealand", "Hawkes Bay", "Ocean Beach Sprint Reverse", "6.61"},
      {"New Zealand", "Hawkes Bay", "Te Awanga Sprint Reverse", "4.79"},
      {"Spain", "Ribadelles", "Comienzo De Bellriu", "14.34"},
      {"Spain", "Ribadelles", "Centenera", "10.57"},
      {"Spain", "Ribadelles", "Ascenso por valle el Gualet", "7.0"},
      {"Spain", "Ribadelles", "Viñedos dentro del valle Parra", "6.81"},
      {"Spain", "Ribadelles", "Viñedos Dardenyà", "6.55"},
      {"Spain", "Ribadelles", "Descenso por carretera", "4.58"},
      {"Spain", "Ribadelles", "Final de Bellriu", "14.34"},
      {"Spain", "Ribadelles", "Camino a Centenera", "10.57"},
      {"Spain", "Ribadelles", "Salida desde Montverd", "7.0"},
      {"Spain", "Ribadelles", "Ascenso bosque Montverd", "6.81"},
      {"Spain", "Ribadelles", "Viñedos Dardenyà inversa", "6.55"},
      {"Spain", "Ribadelles", "Subida por carretera", "4.58"},
      {"USA", "New England", "Beaver Creek Trail Forward", "12.86"},
      {"USA", "New England", "North Fork Pass", "12.5"},
      {"USA", "New England", "Hancock Creek Burst", "6.89"},
      {"USA", "New England", "Fuller Mountain Ascent", "6.64"},
      {"USA", "New England", "Tolt Valley Sprint Forward", "6.1"},
      {"USA", "New England", "Hancock Hill Sprint Forward", "6.01"},
      {"USA", "New England", "Beaver Creek Trail Reverse", "12.86"},
      {"USA", "New England", "North Fork Pass Reverse", "12.5"},
      {"USA", "New England", "Fury Lake Depart", "6.89"},
      {"USA", "New England", "Fuller Mountain Descent", "6.64"},
      {"USA", "New England", "Tolt Valley Sprint Reverse", "6.1"},
      {"USA", "New England", "Hancock Hill Sprint Reverse", "6.01"},
      {"Poland", "Łęczna County", "Zaróbka", "16.46"},
      {"Poland", "Łęczna County", "Zienki", "13.42"},
      {"Poland", "Łęczna County", "Marynka", "9.25"},
      {"Poland", "Łęczna County", "Kopina", "7.03"},
      {"Poland", "Łęczna County", "Lejno", "6.72"},
      {"Poland", "Łęczna County", "Czarny Las", "6.62"},
      {"Poland", "Łęczna County", "Zagórze", "16.46"},
      {"Poland", "Łęczna County", "Jezioro Rotcze", "13.42"},
      {"Poland", "Łęczna County", "Borysik", "9.25"},
      {"Poland", "Łęczna County", "Józefin", "7.03"},
      {"Poland", "Łęczna County", "Jagodno", "6.82"},
      {"Poland", "Łęczna County", "Jezioro Lukie", "6.62"},
      {"Monaco", "Monte Carlo", "Vallée descendante", "10.87"},
      {"Monaco", "Monte Carlo", "Pra d'Alart", "9.83"},
      {"Monaco", "Monte Carlo", "Col de Turini - Départ en descente", "6.85"},
      {"Monaco", "Monte Carlo", "Gordolon - Courte montée", "5.17"},
      {"Monaco", "Monte Carlo", "Col de Turini sprint en montée", "4.73"},
      {"Monaco", "Monte Carlo", "Route de Turini Descente", "3.95"},
      {"Monaco", "Monte Carlo", "Route de Turini", "10.87"},
      {"Monaco", "Monte Carlo", "Col de Turini Départ", "9.83"},
      {"Monaco", "Monte Carlo", "Route de Turini Montée", "6.84"},
      {"Monaco", "Monte Carlo", "Col de Turini - Descente", "5.17"},
      {"Monaco", "Monte Carlo", "Col de Turini - Sprint en descente", "4.73"},
      {"Monaco", "Monte Carlo", "Approche du Col de Turini - Montée", "3.95"},
      {"Sweden", "Värmland", "Hamra", "12.34"},
      {"Sweden", "Värmland", "Ransbysäter", "11.98"},
      {"Sweden", "Värmland", "Elgsjön", "7.28"},
      {"Sweden", "Värmland", "Stor-jangen Sprint", "6.69"},
      {"Sweden", "Värmland", "Älgsjön Sprint", "5.25"},
      {"Sweden", "Värmland", "Östra Hinnsjön", "5.19"},
      {"Sweden", "Värmland", "Lysvik", "12.34"},
      {"Sweden", "Värmland", "Norraskoga", "11.98"},
      {"Sweden", "Värmland", "Älgsjön", "7.28"},
      {"Sweden", "Värmland", "Stor-jangen Sprint Reverse", "6.69"},
      {"Sweden", "Värmland", "Skogsrallyt", "5.25"},
      {"Sweden", "Värmland", "Björklangen", "5.19"},
      {"Germany", "Baumholder", "Oberstein", "11.67"},
      {"Germany", "Baumholder", "Hammerstein", "10.81"},
      {"Germany", "Baumholder", "Kreuzungsring", "6.31"},
      {"Germany", "Baumholder", "Verbundsring", "5.85"},
      {"Germany", "Baumholder", "Innerer Feld-Sprint", "5.56"},
      {"Germany", "Baumholder", "Waldaufstieg", "5.39"},
      {"Germany", "Baumholder", "Frauenberg", "11.67"},
      {"Germany", "Baumholder", "Ruschberg", "10.7"},
      {"Germany", "Baumholder", "Kreuzungsring reverse", "6.31"},
      {"Germany", "Baumholder", "Verbundsring Reverse", "5.85"},
      {"Germany", "Baumholder", "Innerer Feld-Sprint (umgekehrt)", "5.56"},
      {"Germany", "Baumholder", "Waldabstieg", "5.39"},
      {"Finland", "Jämsä", "Kakaristo", "16.2"},
      {"Finland", "Jämsä", "Kontinjärvi", "15.05"},
      {"Finland", "Jämsä", "Kotajärvi", "8.1"},
      {"Finland", "Jämsä", "Iso Oksjärvi", "8.04"},
      {"Finland", "Jämsä", "Kailajärvi", "7.51"},
      {"Finland", "Jämsä", "Naarajärvi", "7.43"},
      {"Finland", "Jämsä", "Pitkäjärvi", "16.2"},
      {"Finland", "Jämsä", "Hämelahti", "14.96"},
      {"Finland", "Jämsä", "Oksala", "8.1"},
      {"Finland", "Jämsä", "Järvenkylä", "8.05"},
      {"Finland", "Jämsä", "Jyrkysjärvi", "7.55"},
      {"Finland", "Jämsä", "Paskuri", "7.34"},
      {"Greece", "Argolis", "Anodou Farmakas", "9.6"},
      {"Greece", "Argolis", "Pomona Érixi", "5.09"},
      {"Greece", "Argolis", "Koryfi Dafni", "4.5"},
      {"Greece", "Argolis", "Perasma Platani", "10.69"},
      {"Greece", "Argolis", "Ourea Spevsi", "5.74"},
      {"Greece", "Argolis", "Abies Koiláda", "7.09"},
      {"Greece", "Argolis", "Kathodo Leontiou", "9.6"},
      {"Greece", "Argolis", "Fourkéta Kourva", "4.5"},
      {"Greece", "Argolis", "Ampelonas Ormi", "4.95"},
      {"Greece", "Argolis", "Tsiristra Théa", "10.36"},
      {"Greece", "Argolis", "Pedines Epidaxi", "5.38"},
      {"Greece", "Argolis", "Ypsona tou Dasos", "6.59"},
      {"Wales", "Powys", "River Severn Valley", "11.4"},
      {"Wales", "Powys", "Sweet Lamb", "9.9"},
      {"Wales", "Powys", "Fferm Wynt", "5.7"},
      {"Wales", "Powys", "Dyffryn Afon", "5.7"},
      {"Wales", "Powys", "Bidno Moorland", "4.9"},
      {"Wales", "Powys", "Pant Mawr", "4.7"},
      {"Wales", "Powys", "Bronfelen", "11.4"},
      {"Wales", "Powys", "Geufron Forest", "10.0"},
      {"Wales", "Powys", "Fferm Wynt Reverse", "5.7"},
      {"Wales", "Powys", "Dyffryn Afon Reverse", "5.7"},
      {"Wales", "Powys", "Bidno Moorland Reverse", "4.8"},
      {"Wales", "Powys", "Pant Mawr Reverse", "5.1"},
      {"Scotland", "Perth and Kinross", "Newhouse Bridge", "12.86"},
      {"Scotland", "Perth and Kinross", "South Morningside", "12.58"},
      {"Scotland", "Perth and Kinross", "Annbank Station", "7.77"},
      {"Scotland", "Perth and Kinross", "Rosebank Farm", "7.16"},
      {"Scotland", "Perth and Kinross", "Old Butterstone Muir", "5.82"},
      {"Scotland", "Perth and Kinross", "Glencastle Farm", "5.25"},
      {"Scotland", "Perth and Kinross", "Newhouse Bridge Reverse", "12.98"},
      {"Scotland", "Perth and Kinross", "South Morningside Reverse", "12.66"},
      {"Scotland", "Perth and Kinross", "Annbank Station Reverse", "7.59"},
      {"Scotland", "Perth and Kinross", "Rosebank Farm Reverse", "6.96"},
      {"Scotland", "Perth and Kinross", "Old Butterstone Muir Reverse", "5.66"},
      {"Scotland", "Perth and Kinross", "Glencastle Farm Reverse", "5.24"}
    ]

    circuits =
      circuits_raw
      |> Enum.map(fn {country, region, name, distance_string} ->
        {distance, ""} = Float.parse(distance_string)

        %{
          game_id: game.id,
          country: country,
          region: region,
          name: name,
          distance: distance,
          inserted_at: now,
          updated_at: now
        }
      end)

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_dirt_rally_2_circuits, Circuit, circuits)
    |> Repo.transaction()

    cars =
      cars_raw
      |> Enum.map(fn {name, class, sub_class} ->
        %{
          game_id: game.id,
          name: name,
          class: class,
          sub_class: sub_class,
          inserted_at: now,
          updated_at: now
        }
      end)

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_dirt_rally_2_cars, Car, cars)
    |> Repo.transaction()
  end

  def down do
    game = Games.get_game_by_code!("dirt-rally-2.0")
    circuits = from(c in Circuit, where: c.game_id == ^game.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_dirt_rally_2_circuits, circuits)
    |> Repo.transaction()

    query = from(c in Circuit, where: c.game_id == ^game.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_dirt_rally_2_cars, query)
    |> Repo.transaction()
  end
end

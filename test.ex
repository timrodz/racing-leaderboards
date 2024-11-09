filename = "rally-stages.json"

with {:ok, body} <- File.read(filename),
     {:ok, json} <- Jason.decode(body) do
  json
  |> Enum.map(fn location ->
    country = location["country"]
    region = location["region"]

    location["stages"]
    |> Enum.map(fn stage ->
      circuit = stage["circuit"]
      distance = stage["distance"]

      %{
        country: country,
        region: region,
        circuit: circuit,
        distance: distance
      }
    end)
  end)
end

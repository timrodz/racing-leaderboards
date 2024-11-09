defmodule RacingLeaderboardsWeb.Utils.Circuits do
  def country_to_emoji(country) do
    case country |> String.downcase() do
      "argentina" -> "🇦🇷"
      "poland" -> "🇵🇱"
      "portugal" -> "🇵🇹"
      "new zealand" -> "🇳🇿"
      "australia" -> "🇦🇺"
      "spain" -> "🇪🇸"
      "usa" -> "🇺🇸"
      "monaco" -> "🇲🇨"
      "sweden" -> "🇸🇪"
      "germany" -> "🇩🇪"
      "finland" -> "🇫🇮"
      "greece" -> "🇬🇷"
      "wales" -> "🏴󠁧󠁢󠁷󠁬󠁳󠁿"
      "scotland" -> "🏴󠁧󠁢󠁳󠁣󠁴󠁿"
      "latvia" -> "🇱🇻"
      "chile" -> "🇨🇱"
      "mexico" -> "🇲🇽"
      "croatia" -> "🇭🇷"
      "italy" -> "🇮🇹"
      "kenya" -> "🇰🇪"
      "estonia" -> "🇪🇪"
      "japan" -> "🇯🇵"
      _ -> country
    end
  end
end

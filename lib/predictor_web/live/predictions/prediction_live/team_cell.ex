defmodule PredictorWeb.Predictions.PredictionLive.TeamCell do
  use PredictorWeb, :live_component

  import PredictorWeb.CoreComponents

  alias Predictor.Competitions.Match
  alias Predictor.Predictions.Prediction
  alias Predictor.Teams.Team

  def render(%{team: %Team{}} = assigns) do
    assigns = assign(assigns, :name, alpha_3_country_code(assigns.team.code))

    ~H"""
    <div class="flex items-center space-x-2">
      <%= if assigns.type == :home_team do %>
        <Flagpack.flag name={@name} class="m-2 w-8 h-8" />
      <% end %>

      <span class="font-bold max-sm:hidden">
        <%= @team.code %>
      </span>

      <%= if assigns.type == :away_team do %>
        <Flagpack.flag name={@name} class="m-2 w-8 h-8" />
      <% end %>
    </div>
    """
  end

  def render(%{match: %Match{user_prediction: nil}, team: nil} = assigns) do
    ~H"""
    <span>
      <.input
        type="select"
        field={@field}
        value={nil}
        form={"prediction-form-#{@match.id}"}
        options={team_options(@teams)}
      />
    </span>
    """
  end

  def render(%{type: :home_team, match: %Match{user_prediction: %Prediction{}}} = assigns) do
    ~H"""
    <span>
      <.input
        type="select"
        field={@field}
        value={@match.user_prediction.home_team_id}
        form={"prediction-form-#{@match.id}"}
        options={team_options(@teams)}
      />
    </span>
    """
  end

  def render(%{type: :away_team, match: %Match{user_prediction: %Prediction{}}} = assigns) do
    ~H"""
    <span>
      <.input
        type="select"
        field={@field}
        value={@match.user_prediction.away_team_id}
        form={"prediction-form-#{@match.id}"}
        options={team_options(@teams)}
      />
    </span>
    """
  end

  defp team_options(teams) do
    [{"---", nil} | Enum.map(teams, &{&1.name, &1.id})]
  end

  defp alpha_3_country_code(code) do
    %{
      "NED" => :nld,
      "ENG" => :gb_eng,
      "IR" => :irl,
      "WAL" => :gb_wls,
      "KSA" => :sau,
      "DEN" => :dnk,
      "CRO" => :hrv,
      "GER" => :deu,
      "CRC" => :cri,
      "SUI" => :che,
      "URU" => :ury,
      "POR" => :prt
    }[code] ||
      code
      |> String.downcase()
      |> String.to_atom()
  end
end

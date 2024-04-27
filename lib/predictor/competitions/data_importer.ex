defmodule Predictor.Competitions.DataImporter do
  @config %{
    "WC2022" => %{
      teams_file: Path.join(File.cwd!(), "priv/data/wc2022_teams.json"),
      matches_file: Path.join(File.cwd!(), "priv/data/wc2022_matches.json")
    }
  }

  @match_default_attrs %{
    status: :scheduled,
    home_goals: 0,
    away_goals: 0,
    home_penaltis: 0,
    away_penalties: 0
  }

  alias Predictor.Repo
  alias Predictor.Teams
  alias Predictor.Competitions.Match

  def import_teams(competition) do
    teams = load_data(competition, :teams_file)

    teams_data =
      Enum.map(
        teams,
        &Map.merge(&1, %{inserted_at: {:placeholder, :now}, updated_at: {:placeholder, :now}})
      )

    placeholders = %{now: now()}

    {_, teams} =
      Repo.insert_all(Teams.Team, teams_data,
        placeholders: placeholders,
        returning: [:id, :name, :code, :type]
      )

    teams
  end

  def import_matches(competition) do
    matches =
      load_data(competition, :matches_file)
      |> Enum.map(&prepare_match_attrs(&1, competition, now()))

    matches_data =
      Enum.map(
        matches,
        &Map.merge(&1, %{inserted_at: {:placeholder, :now}, updated_at: {:placeholder, :now}})
      )

    placeholders = %{now: now()}

    {_, matches} =
      Repo.insert_all(Match, matches_data,
        placeholders: placeholders,
        returning: true
      )

    matches
  end

  defp prepare_match_attrs(
         %{code: code, home_team_code: home_team_code, away_team_code: away_team_code},
         competition,
         timestamp
       ) do
    %{code: code}
    |> Map.merge(@match_default_attrs)
    |> Map.merge(%{
      home_team_id: Teams.get_team_by_code!(home_team_code).id,
      away_team_id: Teams.get_team_by_code!(away_team_code).id,
      competition_id: competition.id,
      kickoff_at: timestamp
    })
  end

  defp prepare_match_attrs(
         %{code: code},
         competition,
         timestamp
       ) do
    %{code: code}
    |> Map.merge(@match_default_attrs)
    |> Map.merge(%{
      competition_id: competition.id,
      kickoff_at: timestamp
    })
  end

  defp load_data(competition, filename) do
    @config
    |> Map.get(competition.name)
    |> Map.get(filename)
    |> File.read!()
    |> Jason.decode!(keys: :atoms)
  end

  defp now do
    DateTime.utc_now() |> DateTime.truncate(:second)
  end
end

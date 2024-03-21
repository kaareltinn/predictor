# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Predictor.Repo.insert!(%Predictor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Predictor.Repo
alias Predictor.Accounts
alias Predictor.Competitions
alias Predictor.Teams
alias Predictor.Competitions.Match
alias Predictor.Predictions

Predictions.delete_all_predictions!()
Accounts.delete_all_users()
{:ok, _user} = Accounts.register_user(%{email: "foo@bar.com", password: "verysecretpassword"})

Competitions.delete_all_competitions()
{:ok, competition} = Competitions.create_competition(%{name: "World Cup 2022"})
Competitions.delete_all_matches(competition.id)

Teams.delete_all_teams()

teams = [
  # Group A
  %{name: "Qatar", code: "QAT", type: "national"},
  %{name: "Ecuador", code: "ECU", type: "national"},
  %{name: "Senegal", code: "SEN", type: "national"},
  %{name: "Netherlands", code: "NED", type: "national"},
  # Group B
  %{name: "England", code: "ENG", type: "national"},
  %{name: "IR Iran", code: "IR", type: "national"},
  %{name: "USA", code: "USA", type: "national"},
  %{name: "Wales", code: "WAL", type: "national"},
  # Group C
  %{name: "Argentina", code: "ARG", type: "national"},
  %{name: "Saudi Arabia", code: "KSA", type: "national"},
  %{name: "Mexico", code: "MEX", type: "national"},
  %{name: "Poland", code: "POL", type: "national"},
  # Group D
  %{name: "France", code: "FRA", type: "national"},
  %{name: "Australia", code: "AUS", type: "national"},
  %{name: "Denmark", code: "DEN", type: "national"},
  %{name: "Tunisia", code: "TUN", type: "national"},
  # Group E
  %{name: "Spain", code: "ESP", type: "national"},
  %{name: "Costa Rica", code: "CRC", type: "national"},
  %{name: "Germany", code: "GER", type: "national"},
  %{name: "Japan", code: "JPN", type: "national"},
  # Group F
  %{name: "Belgium", code: "BEL", type: "national"},
  %{name: "Canada", code: "CAN", type: "national"},
  %{name: "Morocco", code: "MAR", type: "national"},
  %{name: "Croatia", code: "CRO", type: "national"},
  # Group G
  %{name: "Brazil", code: "BRA", type: "national"},
  %{name: "Serbia", code: "SRB", type: "national"},
  %{name: "Switzerland", code: "SUI", type: "national"},
  %{name: "Cameroon", code: "CMR", type: "national"},
  # Group H
  %{name: "Portugal", code: "POR", type: "national"},
  %{name: "Ghana", code: "GHA", type: "national"},
  %{name: "Uruguay", code: "URU", type: "national"},
  %{name: "Korea Republic", code: "KOR", type: "national"}
]

now = DateTime.utc_now() |> DateTime.truncate(:second)

teams_data =
  Enum.map(
    teams,
    &Map.merge(&1, %{inserted_at: {:placeholder, :now}, updated_at: {:placeholder, :now}})
  )

placeholders = %{now: now}

Repo.insert_all(Teams.Team, teams_data, placeholders: placeholders)

match_attrs = fn
  %{code: code, home_team_code: home_team_code, away_team_code: away_team_code} ->
    %{
      code: code,
      status: :scheduled,
      home_team_id: Teams.get_team_by_code!(home_team_code).id,
      away_team_id: Teams.get_team_by_code!(away_team_code).id,
      competition_id: competition.id,
      home_goals: 0,
      away_goals: 0,
      home_penaltis: 0,
      away_penalties: 0,
      kickoff_at: now
    }

  %{code: code} ->
    %{
      code: code,
      status: :scheduled,
      competition_id: competition.id,
      home_goals: 0,
      away_goals: 0,
      home_penaltis: 0,
      away_penalties: 0,
      kickoff_at: now
    }
end

matches = [
  match_attrs.(%{code: "WC2022:1", home_team_code: "QAT", away_team_code: "ECU"}),
  match_attrs.(%{code: "WC2022:2", home_team_code: "SEN", away_team_code: "NED"}),
  match_attrs.(%{code: "WC2022:3", home_team_code: "ENG", away_team_code: "IR"}),
  match_attrs.(%{code: "WC2022:4", home_team_code: "USA", away_team_code: "WAL"}),
  match_attrs.(%{code: "WC2022:5", home_team_code: "ARG", away_team_code: "KSA"}),
  match_attrs.(%{code: "WC2022:6", home_team_code: "DEN", away_team_code: "TUN"}),
  match_attrs.(%{code: "WC2022:7", home_team_code: "MEX", away_team_code: "POL"}),
  match_attrs.(%{code: "WC2022:8", home_team_code: "FRA", away_team_code: "AUS"}),
  match_attrs.(%{code: "WC2022:9", home_team_code: "MAR", away_team_code: "CRO"}),
  match_attrs.(%{code: "WC2022:10", home_team_code: "GER", away_team_code: "JPN"}),
  match_attrs.(%{code: "WC2022:11", home_team_code: "ESP", away_team_code: "CRC"}),
  match_attrs.(%{code: "WC2022:12", home_team_code: "BEL", away_team_code: "CAN"}),
  match_attrs.(%{code: "WC2022:13", home_team_code: "SUI", away_team_code: "CMR"}),
  match_attrs.(%{code: "WC2022:14", home_team_code: "URU", away_team_code: "KOR"}),
  match_attrs.(%{code: "WC2022:15", home_team_code: "POR", away_team_code: "GHA"}),
  match_attrs.(%{code: "WC2022:16", home_team_code: "BRA", away_team_code: "SRB"}),
  match_attrs.(%{code: "WC2022:17", home_team_code: "WAL", away_team_code: "IR"}),
  match_attrs.(%{code: "WC2022:18", home_team_code: "QAT", away_team_code: "SEN"}),
  match_attrs.(%{code: "WC2022:19", home_team_code: "NED", away_team_code: "ECU"}),
  match_attrs.(%{code: "WC2022:20", home_team_code: "ENG", away_team_code: "USA"}),
  match_attrs.(%{code: "WC2022:21", home_team_code: "TUN", away_team_code: "AUS"}),
  match_attrs.(%{code: "WC2022:22", home_team_code: "POL", away_team_code: "KSA"}),
  match_attrs.(%{code: "WC2022:23", home_team_code: "FRA", away_team_code: "DEN"}),
  match_attrs.(%{code: "WC2022:24", home_team_code: "ARG", away_team_code: "MEX"}),
  match_attrs.(%{code: "WC2022:25", home_team_code: "JPN", away_team_code: "CRC"}),
  match_attrs.(%{code: "WC2022:26", home_team_code: "BEL", away_team_code: "MAR"}),
  match_attrs.(%{code: "WC2022:27", home_team_code: "CRO", away_team_code: "CAN"}),
  match_attrs.(%{code: "WC2022:28", home_team_code: "ESP", away_team_code: "GER"}),
  match_attrs.(%{code: "WC2022:29", home_team_code: "CMR", away_team_code: "SRB"}),
  match_attrs.(%{code: "WC2022:30", home_team_code: "KOR", away_team_code: "GHA"}),
  match_attrs.(%{code: "WC2022:31", home_team_code: "BRA", away_team_code: "SUI"}),
  match_attrs.(%{code: "WC2022:32", home_team_code: "POR", away_team_code: "URU"}),
  match_attrs.(%{code: "WC2022:33", home_team_code: "ECU", away_team_code: "SEN"}),
  match_attrs.(%{code: "WC2022:34", home_team_code: "NED", away_team_code: "QAT"}),
  match_attrs.(%{code: "WC2022:35", home_team_code: "WAL", away_team_code: "ENG"}),
  match_attrs.(%{code: "WC2022:36", home_team_code: "IR", away_team_code: "USA"}),
  match_attrs.(%{code: "WC2022:37", home_team_code: "AUS", away_team_code: "DEN"}),
  match_attrs.(%{code: "WC2022:38", home_team_code: "TUN", away_team_code: "FRA"}),
  match_attrs.(%{code: "WC2022:39", home_team_code: "POL", away_team_code: "ARG"}),
  match_attrs.(%{code: "WC2022:40", home_team_code: "KSA", away_team_code: "MEX"}),
  match_attrs.(%{code: "WC2022:41", home_team_code: "CRO", away_team_code: "BEL"}),
  match_attrs.(%{code: "WC2022:42", home_team_code: "CAN", away_team_code: "MAR"}),
  match_attrs.(%{code: "WC2022:43", home_team_code: "JPN", away_team_code: "ESP"}),
  match_attrs.(%{code: "WC2022:44", home_team_code: "CRC", away_team_code: "GER"}),
  match_attrs.(%{code: "WC2022:45", home_team_code: "GHA", away_team_code: "URU"}),
  match_attrs.(%{code: "WC2022:46", home_team_code: "KOR", away_team_code: "POR"}),
  match_attrs.(%{code: "WC2022:47", home_team_code: "SRB", away_team_code: "SUI"}),
  match_attrs.(%{code: "WC2022:48", home_team_code: "CMR", away_team_code: "BRA"}),
  match_attrs.(%{code: "WC2022:49"}),
  match_attrs.(%{code: "WC2022:50"}),
  match_attrs.(%{code: "WC2022:51"}),
  match_attrs.(%{code: "WC2022:52"}),
  match_attrs.(%{code: "WC2022:53"}),
  match_attrs.(%{code: "WC2022:54"}),
  match_attrs.(%{code: "WC2022:55"}),
  match_attrs.(%{code: "WC2022:56"}),
  match_attrs.(%{code: "WC2022:57"}),
  match_attrs.(%{code: "WC2022:58"}),
  match_attrs.(%{code: "WC2022:59"}),
  match_attrs.(%{code: "WC2022:60"}),
  match_attrs.(%{code: "WC2022:61"}),
  match_attrs.(%{code: "WC2022:62"}),
  match_attrs.(%{code: "WC2022:63"}),
  match_attrs.(%{code: "WC2022:64"})
]

matches_data =
  Enum.map(
    matches,
    &Map.merge(&1, %{inserted_at: {:placeholder, :now}, updated_at: {:placeholder, :now}})
  )

Repo.insert_all(Competitions.Match, matches_data, placeholders: placeholders)

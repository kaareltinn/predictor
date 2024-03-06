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

Accounts.delete_all_users()
{:ok, _user} = Accounts.register_user(%{email: "foo@bar.com", password: "verysecretpassword"})

Competitions.delete_all_competitions()
{:ok, competition} = Competitions.create_competition(%{name: "World Cup 2022"})

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

Competitions.delete_all_matches(competition.id)

match_attrs = fn code, home_team_code, away_team_code ->
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
end

matches = [
  match_attrs.("WC2022:1", "QAT", "ECU"),
  match_attrs.("WC2022:2", "SEN", "NED"),
  match_attrs.("WC2022:3", "ENG", "IR"),
  match_attrs.("WC2022:4", "USA", "WAL"),
  match_attrs.("WC2022:5", "ARG", "KSA"),
  match_attrs.("WC2022:6", "DEN", "TUN"),
  match_attrs.("WC2022:7", "MEX", "POL"),
  match_attrs.("WC2022:8", "FRA", "AUS"),
  match_attrs.("WC2022:9", "MAR", "CRO"),
  match_attrs.("WC2022:10", "GER", "JPN"),
  match_attrs.("WC2022:11", "ESP", "CRC"),
  match_attrs.("WC2022:12", "BEL", "CAN"),
  match_attrs.("WC2022:13", "SUI", "CMR"),
  match_attrs.("WC2022:14", "URU", "KOR"),
  match_attrs.("WC2022:15", "POR", "GHA"),
  match_attrs.("WC2022:16", "BRA", "SRB"),
  match_attrs.("WC2022:17", "WAL", "IR"),
  match_attrs.("WC2022:18", "QAT", "SEN"),
  match_attrs.("WC2022:19", "NED", "ECU"),
  match_attrs.("WC2022:20", "ENG", "USA"),
  match_attrs.("WC2022:21", "TUN", "AUS"),
  match_attrs.("WC2022:22", "POL", "KSA"),
  match_attrs.("WC2022:23", "FRA", "DEN"),
  match_attrs.("WC2022:24", "ARG", "MEX"),
  match_attrs.("WC2022:25", "JPN", "CRC"),
  match_attrs.("WC2022:26", "BEL", "MAR"),
  match_attrs.("WC2022:27", "CRO", "CAN"),
  match_attrs.("WC2022:28", "ESP", "GER"),
  match_attrs.("WC2022:29", "CMR", "SRB"),
  match_attrs.("WC2022:30", "KOR", "GHA"),
  match_attrs.("WC2022:31", "BRA", "SUI"),
  match_attrs.("WC2022:32", "POR", "URU"),
  match_attrs.("WC2022:33", "ECU", "SEN"),
  match_attrs.("WC2022:34", "NED", "QAT"),
  match_attrs.("WC2022:35", "WAL", "ENG"),
  match_attrs.("WC2022:36", "IR", "USA"),
  match_attrs.("WC2022:37", "AUS", "DEN"),
  match_attrs.("WC2022:38", "TUN", "FRA"),
  match_attrs.("WC2022:39", "POL", "ARG"),
  match_attrs.("WC2022:40", "KSA", "MEX"),
  match_attrs.("WC2022:41", "CRO", "BEL"),
  match_attrs.("WC2022:42", "CAN", "MAR"),
  match_attrs.("WC2022:43", "JPN", "ESP"),
  match_attrs.("WC2022:44", "CRC", "GER"),
  match_attrs.("WC2022:45", "GHA", "URU"),
  match_attrs.("WC2022:46", "KOR", "POR"),
  match_attrs.("WC2022:47", "SRB", "SUI"),
  match_attrs.("WC2022:48", "CMR", "BRA")
]

matches_data =
  Enum.map(
    matches,
    &Map.merge(&1, %{inserted_at: {:placeholder, :now}, updated_at: {:placeholder, :now}})
  )

Repo.insert_all(Competitions.Match, matches_data, placeholders: placeholders)

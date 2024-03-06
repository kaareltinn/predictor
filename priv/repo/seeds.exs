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

data =
  Enum.map(
    teams,
    &Map.merge(&1, %{inserted_at: {:placeholder, :now}, updated_at: {:placeholder, :now}})
  )

placeholders = %{now: now}

Predictor.Repo.insert_all(Teams.Team, data, placeholders: placeholders)

Competitions.delete_all_matches(competition.id)

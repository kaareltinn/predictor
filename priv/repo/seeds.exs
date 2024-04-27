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
alias Predictor.Competitions.DataImporter

Predictions.delete_all_predictions!()
Accounts.delete_all_users()
{:ok, _user} = Accounts.register_user(%{email: "foo@bar.com", password: "verysecretpassword"})

Competitions.delete_all_competitions()
{:ok, competition} = Competitions.create_competition(%{name: "WC2022"})
Competitions.delete_all_matches(competition.id)

Teams.delete_all_teams()

DataImporter.import_teams(competition)
DataImporter.import_matches(competition)

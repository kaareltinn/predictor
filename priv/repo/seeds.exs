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

Accounts.delete_all_users()
{:ok, _user} = Accounts.register_user(%{email: "foo@bar.com", password: "verysecretpassword"})

Competitions.delete_all_competitions()
Competitions.create_competition(%{name: "World Cup 2022"})

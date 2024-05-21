defmodule Predictor.Repo.Migrations.CreateUsersLeaguesTable do
  use Ecto.Migration

  def change do
    create table(:users_leagues) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :prediction_set_id, references(:prediction_sets, on_delete: :delete_all)
      add :league_id, references(:leagues, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users_leagues, [:user_id, :league_id])
  end
end

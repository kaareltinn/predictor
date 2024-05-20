defmodule Predictor.Repo.Migrations.AddPredictionSetsLeaguesTable do
  use Ecto.Migration

  def change do
    create table(:prediction_sets_leagues) do
      add :prediction_set_id, references(:prediction_sets, on_delete: :delete_all), null: false
      add :league_id, references(:leagues, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:prediction_sets_leagues, [:prediction_set_id, :league_id])
  end
end

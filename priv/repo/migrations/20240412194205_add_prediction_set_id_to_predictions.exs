defmodule Predictor.Repo.Migrations.AddPredictionSetIdToPredictions do
  use Ecto.Migration

  def change do
    alter table(:predictions) do
      add :prediction_set_id, references(:prediction_sets), null: false, on_delete: :delete_all
    end
  end
end

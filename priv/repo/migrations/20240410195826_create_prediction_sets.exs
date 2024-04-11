defmodule Predictor.Repo.Migrations.CreatePredictionSets do
  use Ecto.Migration

  def change do
    create table(:prediction_sets) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :competition_id, references(:competitions, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:prediction_sets, [:user_id])
    create index(:prediction_sets, [:competition_id])
  end
end

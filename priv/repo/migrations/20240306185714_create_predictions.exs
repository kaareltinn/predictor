defmodule Predictor.Repo.Migrations.CreatePredictions do
  use Ecto.Migration

  def change do
    create table(:predictions) do
      add :home_goals, :integer
      add :away_goals, :integer
      add :home_penaltis, :integer
      add :away_penalties, :integer
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :match_id, references(:matches, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:predictions, [:user_id])
    create index(:predictions, [:match_id])
  end
end

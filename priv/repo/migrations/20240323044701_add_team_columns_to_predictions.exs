defmodule Predictor.Repo.Migrations.AddTeamColumnsToPredictions do
  use Ecto.Migration

  def change do
    alter table(:predictions) do
      add :home_team_id, references(:teams)
      add :away_team_id, references(:teams)
    end
  end
end

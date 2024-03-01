defmodule Predictor.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :home_goals, :integer
      add :away_goals, :integer
      add :home_penaltis, :integer
      add :away_penalties, :integer
      add :kickoff_at, :utc_datetime
      add :status, :string
      add :home_team_id, references(:teams, on_delete: :nothing)
      add :away_team_id, references(:teams, on_delete: :nothing)
      add :competition_id, references(:competitions, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:matches, [:home_team_id])
    create index(:matches, [:away_team_id])
    create index(:matches, [:competition_id])
  end
end

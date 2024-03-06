defmodule Predictor.Repo.Migrations.MakeCompetitionIdNotNullInMatchesTable do
  use Ecto.Migration

  def up do
    alter table(:matches) do
      modify :home_team_id, :bigint, null: false
      modify :away_team_id, :bigint, null: false
      modify :competition_id, :bigint, null: false
    end
  end

  def down do
    alter table(:matches) do
      modify :home_team_id, :bigint, null: true
      modify :away_team_id, :bigint, null: true
      modify :competition_id, :bigint, null: true
    end
  end
end

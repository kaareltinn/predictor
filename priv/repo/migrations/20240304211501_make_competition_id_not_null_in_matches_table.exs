defmodule Predictor.Repo.Migrations.MakeCompetitionIdNotNullInMatchesTable do
  use Ecto.Migration

  def up do
    alter table(:matches) do
      modify :competition_id, :bigint, null: false
    end
  end

  def down do
    alter table(:matches) do
      modify :competition_id, :bigint, null: true
    end
  end
end

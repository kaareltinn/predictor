defmodule Predictor.Repo.Migrations.AddStageColumnToMatches do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :stage, :string, null: false
    end
  end
end

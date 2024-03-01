defmodule Predictor.Repo.Migrations.AddUniqueCodeToMatchesTable do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :code, :citext, null: false
    end

    create unique_index(:matches, [:code])
  end
end

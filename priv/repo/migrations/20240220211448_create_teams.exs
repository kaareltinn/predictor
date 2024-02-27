defmodule Predictor.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :code, :string
      add :type, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:teams, [:code])
  end
end

defmodule Predictor.Repo.Migrations.CreateCompetitions do
  use Ecto.Migration

  def change do
    create table(:competitions) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule Predictor.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :entry_code, :string, null: false, unique: true
      add :name, :string, null: false
      add :competition_id, references(:competitions, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:leagues, [:entry_code])
    create index(:leagues, [:competition_id])
  end
end

defmodule Predictor.Repo.Migrations.ChangeCompetitionsMatchesOnDelete do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      modify :competition_id, references(:competitions, on_delete: :delete_all),
        from: references(:competitions, on_delete: :nothing)
    end
  end
end

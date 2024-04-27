defmodule Predictor.Repo.Migrations.ChangePredictionUserIdOnDelete do
  use Ecto.Migration

  def change do
    alter table(:prediction_sets) do
      modify :user_id, references(:users, on_delete: :delete_all),
        from: references(:users, on_delete: :nothing)
    end
  end
end

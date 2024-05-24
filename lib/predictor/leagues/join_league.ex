defmodule Predictor.Leagues.JoinLeague do
  defstruct [:entry_code, :prediction_set_id]

  @types %{
    entry_code: :string,
    prediction_set_id: :integer
  }

  import Ecto.Changeset

  alias Predictor.Leagues

  def changeset(%__MODULE__{} = join_league, attrs) do
    {join_league, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:entry_code, :prediction_set_id])
  end

  def validate_entry_code_exists(changeset) do
    validate_change(changeset, :entry_code, fn field, entry_code ->
      case Leagues.get_league_by_entry_code(entry_code) do
        {:ok, _} -> []
        {:error, :not_found} -> [{field, "invalid entry code"}]
      end
    end)
  end
end

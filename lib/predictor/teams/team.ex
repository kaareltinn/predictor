defmodule Predictor.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :code, :string
    field :name, :string
    field :type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :code, :type])
    |> validate_required([:name, :code, :type])
    |> unique_constraint(:code)
  end
end

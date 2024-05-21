defmodule Predictor.LeaguesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Predictor.Leagues` context.
  """

  alias Predictor.Repo

  @doc """
  Generate a league.
  """
  def league_fixture(attrs \\ %{}) do
    {:ok, league} =
      attrs
      |> Enum.into(%{
        entry_code: "some entry_code",
        name: "some name"
      })
      |> Predictor.Leagues.create_league()

    league
  end

  def user_league_fixture(attrs) do
    placeholders = %{now: DateTime.utc_now() |> DateTime.truncate(:second)}

    Repo.insert_all(
      "users_leagues",
      [
        [
          user_id: attrs.user_id,
          prediction_set_id: attrs[:prediction_set],
          league_id: attrs.league_id,
          inserted_at: {:placeholder, :now},
          updated_at: {:placeholder, :now}
        ]
      ],
      placeholders: placeholders
    )
  end
end

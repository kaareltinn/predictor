defmodule Predictor.Leagues do
  @moduledoc """
  The Leagues context.
  """

  import Ecto.Query, warn: false
  alias Predictor.Repo

  alias Predictor.Leagues.League
  alias Predictor.Leagues.JoinLeague

  @doc """
  Returns the list of leagues.

  ## Examples

      iex> list_leagues()
      [%League{}, ...]

  """
  def list_leagues do
    Repo.all(League)
  end

  @doc """
  Returns the list of user leagues.

  ## Examples

      iex> list_user_leagues(123)
      [%League{}, ...]
  """
  def list_user_leagues(user_id) do
    user_leagues_query =
      from ul in "users_leagues",
        where: ul.user_id == ^user_id,
        select: %{league_id: ul.league_id}

    query =
      from l in League,
        join: ul in subquery(user_leagues_query),
        on: l.id == ul.league_id

    Repo.all(query)
  end

  def upsert_user_league(attrs \\ %{}) do
    placeholders = %{now: DateTime.utc_now() |> DateTime.truncate(:second)}

    Repo.insert_all(
      "users_leagues",
      [
        [
          user_id: attrs.user_id,
          prediction_set_id: attrs[:prediction_set_id],
          league_id: attrs.league_id,
          inserted_at: {:placeholder, :now},
          updated_at: {:placeholder, :now}
        ]
      ],
      on_conflict: {:replace, [:prediction_set_id]},
      conflict_target: [:user_id, :league_id],
      placeholders: placeholders
    )
  end

  def add_user_to_league(user_id, join_league, params) do
    changeset =
      join_league
      |> change_join_league(params)
      |> JoinLeague.validate_entry_code_exists()

    if changeset.valid? do
      {:ok, league} =
        get_league_by_entry_code(Ecto.Changeset.get_field(changeset, :entry_code))

      {1, _} =
        upsert_user_league(%{
          user_id: user_id,
          prediction_set_id: Ecto.Changeset.get_field(changeset, :prediction_set_id),
          league_id: league.id
        })

      :ok
    else
      {:error, changeset}
    end
  end

  @doc """
  Gets a single league.

  Raises `Ecto.NoResultsError` if the League does not exist.

  ## Examples

      iex> get_league!(123)
      %League{}

      iex> get_league!(456)
      ** (Ecto.NoResultsError)

  """
  def get_league!(id), do: Repo.get!(League, id) |> Repo.preload(:competition)

  def get_league_by_entry_code(entry_code) do
    league = Repo.get_by(League, entry_code: entry_code)

    if league do
      {:ok, league}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Creates a league.

  ## Examples

      iex> create_league(%{field: value})
      {:ok, %League{}}

      iex> create_league(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_league(attrs \\ %{}) do
    %League{}
    |> League.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a league.

  ## Examples

      iex> update_league(league, %{field: new_value})
      {:ok, %League{}}

      iex> update_league(league, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_league(%League{} = league, attrs) do
    league
    |> League.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a league.

  ## Examples

      iex> delete_league(league)
      {:ok, %League{}}

      iex> delete_league(league)
      {:error, %Ecto.Changeset{}}

  """
  def delete_league(%League{} = league) do
    Repo.delete(league)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking league changes.

  ## Examples

      iex> change_league(league)
      %Ecto.Changeset{data: %League{}}

  """
  def change_league(%League{} = league, attrs \\ %{}) do
    League.changeset(league, attrs)
  end

  def change_join_league(%JoinLeague{} = join_league, attrs \\ %{}) do
    JoinLeague.changeset(join_league, attrs)
  end
end

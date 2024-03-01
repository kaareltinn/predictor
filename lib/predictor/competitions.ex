defmodule Predictor.Competitions do
  @moduledoc """
  The Competitions context.
  """

  import Ecto.Query, warn: false
  alias Predictor.Repo

  alias Predictor.Competitions.Competition

  @doc """
  Returns the list of competitions.

  ## Examples

      iex> list_competitions()
      [%Competition{}, ...]

  """
  def list_competitions do
    Repo.all(Competition)
  end

  @doc """
  Gets a single competition.

  Raises `Ecto.NoResultsError` if the Competition does not exist.

  ## Examples

      iex> get_competition!(123)
      %Competition{}

      iex> get_competition!(456)
      ** (Ecto.NoResultsError)

  """
  def get_competition!(id), do: Repo.get!(Competition, id)

  @doc """
  Creates a competition.

  ## Examples

      iex> create_competition(%{field: value})
      {:ok, %Competition{}}

      iex> create_competition(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_competition(attrs \\ %{}) do
    %Competition{}
    |> Competition.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a competition.

  ## Examples

      iex> update_competition(competition, %{field: new_value})
      {:ok, %Competition{}}

      iex> update_competition(competition, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_competition(%Competition{} = competition, attrs) do
    competition
    |> Competition.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a competition.

  ## Examples

      iex> delete_competition(competition)
      {:ok, %Competition{}}

      iex> delete_competition(competition)
      {:error, %Ecto.Changeset{}}

  """
  def delete_competition(%Competition{} = competition) do
    Repo.delete(competition)
  end

  def delete_all_competitions do
    Repo.delete_all(Competition)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking competition changes.

  ## Examples

      iex> change_competition(competition)
      %Ecto.Changeset{data: %Competition{}}

  """
  def change_competition(%Competition{} = competition, attrs \\ %{}) do
    Competition.changeset(competition, attrs)
  end

  alias Predictor.Competitions.Match

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches do
    Repo.all(Match)
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id)

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end
end

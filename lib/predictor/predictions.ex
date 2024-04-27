defmodule Predictor.Predictions do
  @moduledoc """
  The Predictions context.
  """

  import Ecto.Query, warn: false
  alias Predictor.Repo

  alias Predictor.Predictions.Prediction

  @doc """
  Returns the list of predictions.

  ## Examples

      iex> list_predictions()
      [%Prediction{}, ...]

  """
  def list_predictions do
    Prediction
    |> Repo.all()
    |> Repo.preload([:user, {:match, [:competition, :home_team, :away_team]}])
  end

  @doc """
  Gets a single prediction.

  Raises `Ecto.NoResultsError` if the Prediction does not exist.

  ## Examples

      iex> get_prediction!(123)
      %Prediction{}

      iex> get_prediction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_prediction!(id) do
    Repo.get!(Prediction, id)
    |> Repo.preload([:user, {:match, [:competition, :home_team, :away_team]}])
  end

  @doc """
  Creates a prediction.

  ## Examples

      iex> create_prediction(%{field: value})
      {:ok, %Prediction{}}

      iex> create_prediction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_prediction(attrs \\ %{}) do
    %Prediction{}
    |> Prediction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a prediction.

  ## Examples

      iex> update_prediction(prediction, %{field: new_value})
      {:ok, %Prediction{}}

      iex> update_prediction(prediction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_prediction(%Prediction{} = prediction, attrs) do
    prediction
    |> Prediction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a prediction.

  ## Examples

      iex> delete_prediction(prediction)
      {:ok, %Prediction{}}

      iex> delete_prediction(prediction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_prediction(%Prediction{} = prediction) do
    Repo.delete(prediction)
  end

  def delete_all_predictions! do
    Repo.delete_all(Prediction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking prediction changes.

  ## Examples

      iex> change_prediction(prediction)
      %Ecto.Changeset{data: %Prediction{}}

  """
  def change_prediction(%Prediction{} = prediction, attrs \\ %{}) do
    Prediction.changeset(prediction, attrs)
  end

  alias Predictor.Predictions.PredictionSet

  @doc """
  Returns the list of prediction_sets.

  ## Examples

      iex> list_prediction_sets()
      [%PredictionSet{}, ...]

  """
  def list_prediction_sets do
    Repo.all(PredictionSet)
  end

  def list_user_prediction_sets(user_id) do
    query =
      from ps in PredictionSet,
        where: ps.user_id == ^user_id

    query
    |> Repo.all()
    |> Repo.preload(:competition)
  end

  @doc """
  Gets a single prediction_set.

  Raises `Ecto.NoResultsError` if the Prediction set does not exist.

  ## Examples

      iex> get_prediction_set!(123)
      %PredictionSet{}

      iex> get_prediction_set!(456)
      ** (Ecto.NoResultsError)

  """
  def get_prediction_set!(id), do: Repo.get!(PredictionSet, id)

  @doc """
  Creates a prediction_set.

  ## Examples

      iex> create_prediction_set(%{field: value})
      {:ok, %PredictionSet{}}

      iex> create_prediction_set(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_prediction_set(attrs \\ %{}) do
    %PredictionSet{}
    |> PredictionSet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a prediction_set.

  ## Examples

      iex> update_prediction_set(prediction_set, %{field: new_value})
      {:ok, %PredictionSet{}}

      iex> update_prediction_set(prediction_set, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_prediction_set(%PredictionSet{} = prediction_set, attrs) do
    prediction_set
    |> PredictionSet.changeset(attrs)
    |> Repo.update()
  end

  def add_prediction(%PredictionSet{} = prediction_set, attrs) do
    attrs =
      attrs
      |> Map.put(:prediction_set, prediction_set)
      |> Map.put(:user, prediction_set.user)

    create_prediction(attrs)

    prediction_set
  end

  @doc """
  Deletes a prediction_set.

  ## Examples

      iex> delete_prediction_set(prediction_set)
      {:ok, %PredictionSet{}}

      iex> delete_prediction_set(prediction_set)
      {:error, %Ecto.Changeset{}}

  """
  def delete_prediction_set(%PredictionSet{} = prediction_set) do
    Repo.delete(prediction_set)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking prediction_set changes.

  ## Examples

      iex> change_prediction_set(prediction_set)
      %Ecto.Changeset{data: %PredictionSet{}}

  """
  def change_prediction_set(%PredictionSet{} = prediction_set, attrs \\ %{}) do
    PredictionSet.changeset(prediction_set, attrs)
  end
end

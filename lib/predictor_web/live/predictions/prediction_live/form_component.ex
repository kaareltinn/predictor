defmodule PredictorWeb.Predictions.PredictionLive.FormComponent do
  use PredictorWeb, :live_component

  alias Predictor.Predictions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= for match_id <- @match_ids do %>
        <.simple_form
          id={"prediction-form-#{match_id}"}
          for={@form}
          phx-target={@myself}
          phx-submit="save"
          phx-update="ignore"
        >
        </.simple_form>
      <% end %>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
    }
  end

  @impl true
  def handle_event(
        "save",
        %{"prediction" => prediction_params, "form_action" => form_action},
        socket
      ) do
    save_prediction(socket, form_action, prediction_params)
  end

  defp save_prediction(socket, "add", params) do
    params =
      params
      |> Map.put("user_id", socket.assigns.user.id)
      |> Map.put("prediction_set_id", socket.assigns.prediction_set.id)

    case Predictions.create_prediction(params) do
      {:ok, prediction} ->
        send(self(), {:saved, prediction})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = traverse_errors(changeset)
        send(self(), {:errors, errors})

        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_prediction(socket, "edit", params) do
    prediction = Predictions.get_prediction!(params["id"])

    case Predictions.update_prediction(prediction, params) do
      {:ok, prediction} ->
        send(self(), {:saved, prediction})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = traverse_errors(changeset)
        send(self(), {:errors, errors})

        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp traverse_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn
      {msg, [validation: :required]} ->
        msg
    end)
    |> Enum.map(fn {key, errors} ->
      "#{key}: #{Enum.join(errors, ", ")}"
    end)
    |> Enum.join("\n")
  end
end

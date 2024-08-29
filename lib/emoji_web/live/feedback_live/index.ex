defmodule EmojiWeb.FeedbackLive.Index do
  use EmojiWeb, :live_view

  alias Emoji.Feedbacks
  alias Emoji.Feedbacks.Feedback
  alias Emoji.Repo

  @impl true
  def mount(%{"event" => event}, _session, socket) do
    if connected?(socket), do: Feedbacks.Operation.subscribe()

    changeset = Feedbacks.Feedback.changeset(%Feedback{}, %{})

    # Get user by socket_id
    user = Repo.get_by(Feedback, socket_id: socket.id)

    socket =
      socket
      |> assign(:feedbacks, Feedbacks.Operation.list_feedbacks_by_event(event))
      |> assign(:event, event)
      |> assign(:form, to_form(changeset))
      |> assign(:show_dialog, !user)

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"feedback" => feedback_params}, socket) do
    params =
      feedback_params
      |> Map.put("event", socket.assigns.event)
      |> Map.put("socket_id", socket.id)

    case Feedbacks.Operation.create_feedback_and_broadcast(params) do
      {:ok, _feedback} ->
        socket =
          socket
          |> put_flash(:info, "Feedback created successfully.")
          |> push_navigate(to: ~p"/#{socket.assigns.event}")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:feedback_created, feedback}, socket) do
    {:noreply, update(socket, :feedbacks, fn feedbacks -> [feedback | feedbacks] end)}
  end
end

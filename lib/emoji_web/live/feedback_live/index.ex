defmodule EmojiWeb.FeedbackLive.Index do
  use EmojiWeb, :live_view

  alias Emoji.Feedbacks
  alias Emoji.Feedbacks.Feedback
  alias Emoji.Repo

  @impl true
  def mount(%{"event" => event}, _session, socket) do
    if connected?(socket), do: Feedbacks.Operation.subscribe()

    changeset = Feedbacks.Feedback.changeset(%Feedback{}, %{})

    user = Repo.get_by(Feedback, socket_id: socket.id)

    {feedback, feedbacks} = Feedbacks.Operation.list_feedbacks_by_event(event) |> List.pop_at(0)

    socket =
      socket
      |> assign(:feedbacks, feedbacks)
      |> assign(:feedback, feedback)
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
          |> push_navigate(to: ~p"/#{socket.assigns.event}")

        # |> put_flash(:info, "Feedback created successfully.")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:feedback_created, _feedback}, socket) do
    {feedback, feedbacks} =
      Feedbacks.Operation.list_feedbacks_by_event(socket.assigns.event) |> List.pop_at(0)

    socket =
      socket
      |> update(:feedbacks, fn _ -> feedbacks end)
      |> update(:feedback, fn _ -> feedback end)

    dbg(socket.assigns.feedback)
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <dialog open={assigns[:show_dialog]} id="feedback-dialog" class="modal backdrop-brightness-75">
      <div class="modal-box bg-opacity-85">
        <.form for={@form} id="feedback-form" phx-submit="submit" method="modal">
          <h3 class="text-xl font-bold">Give me some feedback</h3>
          <div class="rating gap-1 py-4">
            <input type="radio" name="feedback[emoji]" class="mask mask-heart bg-red-400" value="1" />
            <input
              type="radio"
              name="feedback[emoji]"
              class="mask mask-heart bg-orange-400"
              value="2"
            />
            <input
              type="radio"
              name="feedback[emoji]"
              class="mask mask-heart bg-yellow-400"
              checked="checked"
              value="3"
            />
            <input type="radio" name="feedback[emoji]" class="mask mask-heart bg-lime-400" value="4" />
            <input type="radio" name="feedback[emoji]" class="mask mask-heart bg-green-400" value="5" />
          </div>
          <div class="">
            <button class="btn" type="submit">Submit</button>
          </div>
        </.form>
      </div>
    </dialog>

    <div
      :for={feedback <- @feedbacks}
      style={"position: absolute; left: #{Enum.random(0..100)}%; top: #{Enum.random(0..100)}%;"}
      class="ease-in duration-300 hover:scale-110 transform transition-all"
    >
      <span class="text-3xl"><%= feedback.emoji %></span>
    </div>

    <div
      style={"position: absolute; left: #{Enum.random(0..100)}%; top: #{Enum.random(0..100)}%;"}
      class="animate-ping ease-in duration-300 hover:scale-110 transform transition-all"
    >
      <span class="text-3xl"><%= @feedback.emoji %></span>
    </div>
    """
  end
end

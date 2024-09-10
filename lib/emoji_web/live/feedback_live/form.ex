defmodule EmojiWeb.FeedbackLive.Form do
  use EmojiWeb, :live_view

  alias Emoji.Feedbacks
  alias Emoji.Feedbacks.Feedback

  @impl true
  def mount(_params, _session, socket) do
    changeset = Feedbacks.Feedback.changeset(%Feedback{}, %{})

    socket =
      socket
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"feedback" => feedback} = feedback_params, socket) do
    emoji = Map.get(feedback, "emoji")

    params =
      feedback_params
      |> Map.put("event", "javascriptbangkok")
      |> Map.put("socket_id", socket.id)
      |> Map.put("emoji", emoji)

    case Feedbacks.create_feedback(params) do
      {:ok, _feedback} ->
        socket =
          socket
          |> put_flash(:info, "Feedback created successfully.")
          |> push_navigate(to: ~p"/feedback/thanks")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))
          |> assign(:is_error, true)

        {:noreply, socket}
    end
  end

  def handle_event("submit", _params, socket) do
    changeset =
      Feedbacks.Feedback.changeset(%Feedback{}, %{
        "event" => "javascriptbangkok",
        "socket_id" => socket.id
      })

    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> assign(:is_error, true)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%= if Map.get(assigns, :is_error) do %>
      <div role="alert" class="alert">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-6 w-6 shrink-0 stroke-current"
          fill="none"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
          />
        </svg>
        <ul>
          <li :for={{type, {message, _}} <- @form.source.errors}>
            <%= Atom.to_string(type) %> <%= message %>
          </li>
        </ul>
      </div>
    <% end %>
    <div class="flex justify-center">
      <div class="modal-box bg-opacity-85">
        <.form for={@form} id="feedback-form" phx-submit="submit">
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
              value="3"
            />
            <input type="radio" name="feedback[emoji]" class="mask mask-heart bg-lime-400" value="4" />
            <input type="radio" name="feedback[emoji]" class="mask mask-heart bg-green-400" value="5" />
          </div>
          <div class="actions">
            <button class="btn" type="submit">Submit</button>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end

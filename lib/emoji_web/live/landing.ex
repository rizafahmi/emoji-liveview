defmodule EmojiWeb.Landing do
  use EmojiWeb, :live_view

  alias Emoji.Feedbacks.Operation, as: Feedbacks

  @impl true
  def mount(_params, _session, socket) do
    events = Feedbacks.list_events()

    socket =
      socket
      |> assign(:events, events)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container flex">
      <%= for event <- @events do %>
        <div
          onclick={"qrmodal#{event}.showModal()"}
          class="card bg-primary cursor-pointer image-full w-96 shadow-xl my-6 mx-4"
        >
          <figure>
            <img src={"data:image/png; base64, #{qr_blob(event)}"} alt="QR Code" />
          </figure>
          <div class="card-body">
            <h2 class="card-title"><%= event %></h2>
          </div>
        </div>
        <dialog id={"qrmodal#{event}"} class="modal">
          <div class="modal-box">
            <.link navigate={~p"/#{event}"} class="text-lg font-bold my-6"><%= event %></.link>
            <div class="divider"></div>
            <figure>
              <img src={"data:image/png; base64, #{qr_blob(event)}"} alt="Shoes" />
            </figure>
          </div>
          <form method="dialog" class="modal-backdrop">
            <button>close</button>
          </form>
        </dialog>
      <% end %>

      <%= if @events == [] do %>
        <div role="alert" class="alert alert-warning">
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
              d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
            />
          </svg>
          <span>No events, yet.</span>
        </div>
      <% end %>
    </div>
    """
  end

  defp qr_blob(event) do
    {:ok, qr_blob} =
      "http://localhost:4000/#{event}"
      |> QRCode.create()
      |> QRCode.render(:png)
      |> QRCode.to_base64()

    qr_blob
  end
end

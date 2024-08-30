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
        class="card bg-primary image-full w-96 shadow-xl my-6 mx-4"
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

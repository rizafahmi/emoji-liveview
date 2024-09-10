defmodule EmojiWeb.PageController do
  use EmojiWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def reset(conn, _params) do
    Emoji.Extras.delete_all_feedbacks()

    conn
    |> put_flash(:info, "Feedbacks reset")
    |> redirect(to: "/")
  end
end

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

  def feedbacks(conn, %{"password" => password}) do
    if password == "kaos" do
      feedbacks = Emoji.Feedbacks.list_feedbacks()

      render(conn, "feedbacks.html", feedbacks: feedbacks)
    else
      conn
      |> put_flash(:error, "Invalid password")
      |> redirect(to: "/")
    end
  end
end

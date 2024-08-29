defmodule EmojiWeb.FeedbackLiveTest do
  use EmojiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Emoji.FeedbacksFixtures

  defp create_feedback(_) do
    feedback = feedback_fixture()
    %{feedback: feedback}
  end

  describe "Index" do
    setup [:create_feedback]

    test "lists all feedbacks", %{conn: conn, feedback: feedback} do
      {:ok, _index_live, html} = live(conn, ~p"/event")
      assert html =~ feedback.emoji
    end
  end
end

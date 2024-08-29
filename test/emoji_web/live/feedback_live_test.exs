defmodule EmojiWeb.FeedbackLiveTest do
  use EmojiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Emoji.FeedbacksFixtures

  @create_attrs %{emoji: "some emoji", event: "some event"}
  @update_attrs %{emoji: "some updated emoji", event: "some updated event"}
  @invalid_attrs %{emoji: nil, event: nil}

  defp create_feedback(_) do
    feedback = feedback_fixture()
    %{feedback: feedback}
  end

  describe "Index" do
    setup [:create_feedback]

    test "lists all feedbacks", %{conn: conn, feedback: feedback} do
      {:ok, _index_live, html} = live(conn, ~p"/feedbacks")

      assert html =~ "Listing Feedbacks"
      assert html =~ feedback.emoji
    end

    test "saves new feedback", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/feedbacks")

      assert index_live |> element("a", "New Feedback") |> render_click() =~
               "New Feedback"

      assert_patch(index_live, ~p"/feedbacks/new")

      assert index_live
             |> form("#feedback-form", feedback: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#feedback-form", feedback: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/feedbacks")

      html = render(index_live)
      assert html =~ "Feedback created successfully"
      assert html =~ "some emoji"
    end

    test "updates feedback in listing", %{conn: conn, feedback: feedback} do
      {:ok, index_live, _html} = live(conn, ~p"/feedbacks")

      assert index_live |> element("#feedbacks-#{feedback.id} a", "Edit") |> render_click() =~
               "Edit Feedback"

      assert_patch(index_live, ~p"/feedbacks/#{feedback}/edit")

      assert index_live
             |> form("#feedback-form", feedback: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#feedback-form", feedback: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/feedbacks")

      html = render(index_live)
      assert html =~ "Feedback updated successfully"
      assert html =~ "some updated emoji"
    end

    test "deletes feedback in listing", %{conn: conn, feedback: feedback} do
      {:ok, index_live, _html} = live(conn, ~p"/feedbacks")

      assert index_live |> element("#feedbacks-#{feedback.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#feedbacks-#{feedback.id}")
    end
  end

  describe "Show" do
    setup [:create_feedback]

    test "displays feedback", %{conn: conn, feedback: feedback} do
      {:ok, _show_live, html} = live(conn, ~p"/feedbacks/#{feedback}")

      assert html =~ "Show Feedback"
      assert html =~ feedback.emoji
    end

    test "updates feedback within modal", %{conn: conn, feedback: feedback} do
      {:ok, show_live, _html} = live(conn, ~p"/feedbacks/#{feedback}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Feedback"

      assert_patch(show_live, ~p"/feedbacks/#{feedback}/show/edit")

      assert show_live
             |> form("#feedback-form", feedback: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#feedback-form", feedback: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/feedbacks/#{feedback}")

      html = render(show_live)
      assert html =~ "Feedback updated successfully"
      assert html =~ "some updated emoji"
    end
  end
end

defmodule Emoji.FeedbacksTest do
  use Emoji.DataCase

  alias Emoji.Feedbacks

  describe "feedbacks" do
    alias Emoji.Feedbacks.Feedback

    import Emoji.FeedbacksFixtures

    @invalid_attrs %{emoji: nil, event: nil}

    test "list_feedbacks/0 returns all feedbacks" do
      feedback = feedback_fixture()
      assert Feedbacks.list_feedbacks() == [feedback]
    end

    test "get_feedback!/1 returns the feedback with given id" do
      feedback = feedback_fixture()
      assert Feedbacks.get_feedback!(feedback.id) == feedback
    end

    test "create_feedback/1 with valid data creates a feedback" do
      valid_attrs = %{emoji: "some emoji", event: "some event"}

      assert {:ok, %Feedback{} = feedback} = Feedbacks.create_feedback(valid_attrs)
      assert feedback.emoji == "some emoji"
      assert feedback.event == "some event"
    end

    test "create_feedback/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feedbacks.create_feedback(@invalid_attrs)
    end

    test "update_feedback/2 with valid data updates the feedback" do
      feedback = feedback_fixture()
      update_attrs = %{emoji: "some updated emoji", event: "some updated event"}

      assert {:ok, %Feedback{} = feedback} = Feedbacks.update_feedback(feedback, update_attrs)
      assert feedback.emoji == "some updated emoji"
      assert feedback.event == "some updated event"
    end

    test "update_feedback/2 with invalid data returns error changeset" do
      feedback = feedback_fixture()
      assert {:error, %Ecto.Changeset{}} = Feedbacks.update_feedback(feedback, @invalid_attrs)
      assert feedback == Feedbacks.get_feedback!(feedback.id)
    end

    test "delete_feedback/1 deletes the feedback" do
      feedback = feedback_fixture()
      assert {:ok, %Feedback{}} = Feedbacks.delete_feedback(feedback)
      assert_raise Ecto.NoResultsError, fn -> Feedbacks.get_feedback!(feedback.id) end
    end

    test "change_feedback/1 returns a feedback changeset" do
      feedback = feedback_fixture()
      assert %Ecto.Changeset{} = Feedbacks.change_feedback(feedback)
    end
  end
end

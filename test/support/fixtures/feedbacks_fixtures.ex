defmodule Emoji.FeedbacksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Emoji.Feedbacks` context.
  """

  @doc """
  Generate a feedback.
  """
  def feedback_fixture(attrs \\ %{}) do
    {:ok, feedback} =
      attrs
      |> Enum.into(%{
        emoji: "some emoji",
        event: "event",
        socket_id: "some socket_id"
      })
      |> Emoji.Feedbacks.create_feedback()

    feedback
  end
end

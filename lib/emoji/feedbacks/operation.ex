defmodule Emoji.Feedbacks.Operation do
  @moduledoc """
  Extra operations for the Feedbacks context.
  """

  import Ecto.Query, warn: false
  alias Emoji.Repo

  alias Emoji.Feedbacks.Feedback

  def list_feedbacks_by_event(event) do
    Repo.all(from f in Feedback, where: f.event == ^event)
  end

  def create_feedback_and_broadcast(attrs \\ %{}) do
    result = Emoji.Feedbacks.create_feedback(attrs)
    broadcast(result, :feedback_created)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Emoji.PubSub, "feedbacks")
  end

  def list_events() do
    Repo.all(from f in Feedback, distinct: true, select: f.event)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, feedback}, event) do
    Phoenix.PubSub.broadcast(Emoji.PubSub, "feedbacks", {event, feedback})
    {:ok, feedback}
  end
end

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
end

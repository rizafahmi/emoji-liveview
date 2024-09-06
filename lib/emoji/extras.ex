defmodule Emoji.Extras do
  def delete_all_feedbacks() do
    Emoji.Repo.delete_all(Emoji.Feedbacks.Feedback)
  end
end

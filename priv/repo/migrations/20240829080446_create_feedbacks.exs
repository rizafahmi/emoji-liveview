defmodule Emoji.Repo.Migrations.CreateFeedbacks do
  use Ecto.Migration

  def change do
    create table(:feedbacks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :event, :string
      add :emoji, :text

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule Emoji.Repo.Migrations.AddSocketId do
  use Ecto.Migration

  def change do
    alter table(:feedbacks) do
      add :socket_id, :string
    end
  end
end

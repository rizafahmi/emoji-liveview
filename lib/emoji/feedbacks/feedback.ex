defmodule Emoji.Feedbacks.Feedback do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "feedbacks" do
    field :emoji, :string
    field :event, :string
    field :socket_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(feedback, attrs) do
    feedback
    |> cast(attrs, [:event, :emoji, :socket_id])
    |> generate_emoji()
    |> validate_required([:event, :emoji, :socket_id])
  end

  defp generate_emoji(changeset) do
    case get_change(changeset, :emoji) do
      "1" ->
        put_change(
          changeset,
          :emoji,
          ["😥", "😢", "😞", "😔", "😕", "😱", "😖", "😫", "😩", "😤", "😓", "😣", "🤡"] |> Enum.random()
        )

      "2" ->
        put_change(
          changeset,
          :emoji,
          [
            "😐",
            "😑",
            "😒",
            "😔",
            "😕",
            "😖",
            "😞",
            "😟",
            "😠",
            "😣",
            "😤",
            "😥",
            "😦",
            "😧",
            "😨",
            "😩",
            "😫",
            "😮",
            "😯",
            "😴",
            "😵",
            "😶",
            "😷",
            "🙁"
          ]
          |> Enum.random()
        )

      "3" ->
        put_change(
          changeset,
          :emoji,
          [
            "😬",
            "🫡",
            "👍🏼",
            "👍🏻",
            "👍🏽",
            "👍🏾",
            "👍🏿",
            "👍",
            "👌🏼",
            "👌🏻",
            "👌🏽",
            "👌🏾",
            "👌🏿",
            "👌",
            "🤌🏼",
            "🤌🏻",
            "🤌🏽",
            "🤌🏾",
            "🤌🏿",
            "🤌",
            "🤏🏼",
            "🤏🏻",
            "🤏🏽",
            "🤏🏾",
            "🤏🏿",
            "🤏",
            "🤞🏼",
            "🤞🏻",
            "🤞🏽",
            "🤞🏾",
            "🤞🏿",
            "🤞",
            "🤟🏼",
            "🤟🏻",
            "🤟🏽",
            "🤟🏾",
            "🤟🏿",
            "🤟",
            "🤘🏼",
            "🤘🏻",
            "🤘🏽",
            "🤘🏾",
            "🤘🏿",
            "🤘",
            "🤙🏼",
            "🤙🏻",
            "🤙🏽",
            "🤙🏾",
            "🤙🏿",
            "🤙",
            "👈🏼",
            "👈🏻",
            "👈🏽",
            "👈🏾",
            "👈🏿",
            "👈",
            "👉🏼",
            "👉🏻",
            "👉🏽"
          ]
          |> Enum.random()
        )

      "4" ->
        put_change(
          changeset,
          :emoji,
          [
            "😀",
            "😁",
            "😂",
            "🤣",
            "😃",
            "😄",
            "😅",
            "😆",
            "😉",
            "😊",
            "😋",
            "😎",
            "😍",
            "😘",
            "😗",
            "😙",
            "😚",
            "🙂",
            "🤗"
          ]
          |> Enum.random()
        )

      "5" ->
        put_change(
          changeset,
          :emoji,
          [
            "🎉",
            "🎊",
            "🎈",
            "🎇",
            "🎆",
            "🎁",
            "🎀",
            "🎗",
            "🎟",
            "🎫",
            "🏆",
            "🏅",
            "🥇",
            "🤛",
            "🤜",
            "🤝",
            "🤩",
            "💫",
            "⭐",
            "🌟",
            "💥"
          ]
          |> Enum.random()
        )

      nil ->
        changeset
    end
  end
end

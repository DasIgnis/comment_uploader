defmodule CommentUploader.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias CommentFilter.Validators

  schema "comments" do
    field :city, :string
    field :daytime, :string
    field :emote, :string
    field :gender, :string
    field :month, :integer
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text, :gender, :city, :emote, :month, :daytime])
    |> validate_required([:text, :gender, :city, :emote, :month, :daytime])
    |> validate_length(:text, min: 2)
    |> validate_inclusion(:month, 1..12)
    |> Validators.validate_gender()
    |> Validators.validate_daytime()
  end
end

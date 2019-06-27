defmodule CommentUploader.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :text
      add :gender, :string
      add :city, :string
      add :emote, :string
      add :month, :integer
      add :daytime, :string

      timestamps()
    end

  end
end

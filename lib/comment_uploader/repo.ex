defmodule CommentUploader.Repo do
  use Ecto.Repo,
    otp_app: :comment_uploader,
    adapter: Ecto.Adapters.Postgres
end

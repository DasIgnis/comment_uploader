use Mix.Config

# Configure your database
config :comment_uploader, CommentUploader.Repo,
  username: "postgres",
  password: "qwerty",
  database: "comment_uploader_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :comment_uploader, CommentUploaderWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

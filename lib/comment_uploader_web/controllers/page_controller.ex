defmodule CommentUploaderWeb.PageController do
  use CommentUploaderWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule CommentUploaderWeb.PageControllerTest do
  use CommentUploaderWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "В базе данных"
  end
end

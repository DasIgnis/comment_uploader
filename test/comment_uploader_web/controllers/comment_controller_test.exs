defmodule CommentUploaderWeb.CommentControllerTest do
  use CommentUploaderWeb.ConnCase

  alias CommentUploader.Comments

  describe "index" do
    test "leads to main page", %{conn: conn} do
      conn = get(conn, Routes.comment_path(conn, :index))
      assert html_response(conn, 200) =~ "В базе данных"
    end
  end

  describe "create" do
    test "Responds everything is OK if we send suiting file", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixtures/correct.csv", content_type: "text/csv", filename: "correct.csv"}
      conn = post(conn, Routes.comment_path(conn, :create), %{"comment" => %{"csv" => upload}})
      assert html_response(conn, 200) =~ "Comments created successfully"
    end

    test "Shows an error message if file has wrong format", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixtures/uncorrect.txt", content_type: "text/plain", filename: "uncorrect.txt"}
      conn = post(conn, Routes.comment_path(conn, :create), %{"comment" => %{"csv" => upload}})
      assert html_response(conn, 200) =~ "Wrong file format"
    end

    test "Shows an error message for csv with uncorrect content", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixtures/uncorrect.csv", content_type: "text/csv", filename: "uncorrect.csv"}
      conn = post(conn, Routes.comment_path(conn, :create), %{"comment" => %{"csv" => upload}})
      assert html_response(conn, 200) =~ "Error uploading file"
    end

    test "Shows an error if we don't send any file", %{conn: conn} do
      conn = post(conn, Routes.comment_path(conn, :create))
      assert html_response(conn, 200) =~ "No file selected"
    end
  end

end

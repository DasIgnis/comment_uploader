defmodule CommentUploaderWeb.ReportController do
  use CommentUploaderWeb, :controller
  alias CommentUploader.QueryHelper
  alias CommentUploader.Comments.Comment
  alias CommentUploader.FileProcessor

  def create(conn, %{"comment" => report_params}) do
    if (report_params["param"] == "" || report_params["report_f"] == "") do
      conn
        |> put_flash(:error, "Empty parameters")
        |> assign(:changeset, Comment.changeset(%Comment{}, %{}))
        |> render(CommentUploaderWeb.CommentView, "index.html")
    else
      IO.puts("IT GOES THIS WAY")
      param = report_params["param"]
      data = case QueryHelper.fetch_data(param) do
        {:ok, data} -> data
        :error -> conn
          |> put_flash(:error, "Error processing params")
          |> assign(:changeset, Comment.changeset(%Comment{}, %{}))
          |> render(CommentUploaderWeb.CommentView, "index.html")
      end
      format = report_params["report_f"]
      case format do
        "html" -> conn
          |> assign(:data, data)
          |> render("show_report.html")
        "excel" ->
          case FileProcessor.generate_excel_file(data) do
            {:ok, path} -> FileProcessor.init_download(conn, path)
            {:error, _} -> put_flash(conn, :error, "Error with downloading file, try again")
          end
          conn
          |> assign(:changeset, Comment.changeset(%Comment{}, %{}))
          |> render(CommentUploaderWeb.CommentView, "index.html")
      end
    end
  end
end

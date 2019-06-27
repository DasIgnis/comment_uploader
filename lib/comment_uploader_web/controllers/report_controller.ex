defmodule CommentUploaderWeb.ReportController do
  use CommentUploaderWeb, :controller
  alias CommentUploader.QueryHelper
  alias CommentUploader.Comments.Comment

  def create(conn, %{"comment" => report_params}) do
    unless (report_params["param"] && report_params["report_f"]) do
      conn
        |> put_flash(:error, "Empty parameters")
        |> assign(:changeset, Comment.changeset(%Comment{}, %{}))
        |> render(CommentUploaderWeb.CommentView, "index.html")
    end
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
    end
  end
end

defmodule CommentUploaderWeb.ReportController do
  use CommentUploaderWeb, :controller
  alias CommentUploader.QueryHelper
  alias CommentUploader.Comments.Comment
  alias CommentUploader.FileProcessor

  def create(conn, %{"comment" => report_params}) do
    status = if (report_params["param"] == "" || report_params["report_f"] == "") do
        %{key: :error, message: "Empty parameters"}
      else
        param = report_params["param"]
        data = case QueryHelper.fetch_data(param) do
          {:ok, data} -> data
          :error -> %{key: :error, message: "Error processing params"}
        end
        format = report_params["report_f"]
        case format do
          "html" -> conn
            |> assign(:data, data)
            |> render("show_report.html")
            %{key: :info, message: "Showing report"}
          "excel" ->
            case FileProcessor.generate_excel_file(data) do
              {:ok, path} -> FileProcessor.init_download(conn, path)
                  %{key: :info, message: "File download started"}
              {:error, _} -> %{key: :error, message: "Error downloading file, try again"}
            end
        end
      end
    conn
    |> put_flash(status.key, status.message)
    |> assign(:changeset, Comment.changeset(%Comment{}, %{}))
    |> render(CommentUploaderWeb.CommentView, "index.html")
  end
end

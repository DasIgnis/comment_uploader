defmodule CommentUploaderWeb.CommentController do
  use CommentUploaderWeb, :controller
  alias CommentFilter.Repo
  alias CommentUploader.Comments
  alias CommentUploader.Comments.Comment
  alias CommentFilter.FileProcessor
  import Ecto.Query

  def index(conn, _params) do
    comments = Comments.list_comments()
    changeset = Comments.change_comment(%Comment{})
    render(conn, "index.html", comments: comments, changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    IO.inspect comment_params
    if upload = comment_params["csv"] do
      extension = Path.extname(upload.filename)
      if extension == ".csv" do
        FileProcessor.upload_data(upload.path)
        case Comments.create_comment(comment_params) do
          {:ok, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:info, "Comment created successfully.")
            |> render("index.html", changeset: changeset, comments: Comments.list_comments())

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:info, "Error uploading file.")
            |> render("index.html", changeset: changeset, comments: Comments.list_comments())
            #render(conn, "index.html", changeset: changeset)
            #text(conn, "Error")
        end
      end
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end


end

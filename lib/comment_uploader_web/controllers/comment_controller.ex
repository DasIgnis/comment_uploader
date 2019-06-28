defmodule CommentUploaderWeb.CommentController do
  use CommentUploaderWeb, :controller
  alias CommentUploader.Comments.Comment
  alias CommentUploader.FileProcessor
  alias CommentUploader.Repo

  def index(conn, _params) do
    changeset = Comment.changeset(%Comment{}, %{})
    render(conn, "index.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    upload = comment_params["csv"]
    extension = Path.extname(upload.filename)

    if extension == ".csv" do
      comment_list = FileProcessor.upload_data(upload.path)
      changesets = Enum.map(comment_list, fn comment ->
        Comment.changeset(%Comment{}, comment)
      end)

      result = changesets
        |> Enum.with_index()
        |> Enum.reduce(Ecto.Multi.new(), fn ({changeset, index}, multi) ->
            Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
        end)
        |> Repo.transaction

      case result do
        {:ok, _} ->
          conn
            |> put_flash(:info, "Comments created successfully.")
            |> assign(:changeset, Comment.changeset(%Comment{}, %{}))
            |> render("index.html")

        {:error, _, changeset, _} ->
          conn
            |> put_flash(:error, "Error uploading file.")
            |> render("index.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Wrong file format")
      |> assign(:changeset, Comment.changeset(%Comment{}, %{}))
      |> render("index.html")
    end
  end

  def create(conn, _) do
    conn
      |> put_flash(:error, "No file selected")
      |> assign(:changeset, Comment.changeset(%Comment{}, %{}))
      |> render("index.html")
  end


end

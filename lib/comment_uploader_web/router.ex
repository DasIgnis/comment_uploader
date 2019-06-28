defmodule CommentUploaderWeb.Router do
  use CommentUploaderWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CommentUploaderWeb do
    pipe_through :browser

    get "/", CommentController, :index

    resources "/comments", CommentController, only: [:create, :index]
    resources "/reports", ReportController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CommentUploaderWeb do
  #   pipe_through :api
  # end
end

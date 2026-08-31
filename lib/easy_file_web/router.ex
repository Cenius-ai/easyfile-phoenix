defmodule EasyFileWeb.Router do
  use EasyFileWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EasyFileWeb.Auth, :fetch_current_user
  end

  pipeline :authenticated do
    plug EasyFileWeb.Auth, :require_authenticated_user
  end

  pipeline :guest_only do
    plug EasyFileWeb.Auth, :redirect_if_authenticated
  end

  scope "/", EasyFileWeb do
    pipe_through [:browser, :guest_only]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", EasyFileWeb do
    pipe_through [:browser, :authenticated]

    get "/", FileController, :index
    get "/files", FileController, :index
    get "/files/new", FileController, :new
    post "/files", FileController, :create
    get "/logout", SessionController, :delete
  end
end

defmodule EasyFileWeb.SessionController do
  use EasyFileWeb, :controller

  alias EasyFile.Accounts

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> EasyFileWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back, #{user.email}!")
        |> redirect(to: "/files")

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid email or password. Please try again.")
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> EasyFileWeb.Auth.logout()
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: "/login")
  end
end

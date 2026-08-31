defmodule EasyFileWeb.SessionControllerTest do
  use EasyFileWeb.ConnCase, async: false

  alias EasyFile.Repo
  alias EasyFile.Accounts.User

  setup do
    Ecto.Migrator.run(EasyFile.Repo, :up, all: true)

    user =
      case Repo.get_by(User, email: "cenius@cenius.ai") do
        nil ->
          {:ok, u} = EasyFile.Accounts.create_user(%{
            email: "cenius@cenius.ai",
            password: "cenius"
          })
          u

        existing ->
          existing
      end

    {:ok, user: user}
  end

  test "GET /login renders login form", %{conn: conn} do
    conn = get(conn, "/login")
    assert html_response(conn, 200) =~ "EasyFile"
    assert html_response(conn, 200) =~ "Sign in"
  end

  test "GET /login shows demo credentials hint", %{conn: conn} do
    conn = get(conn, "/login")
    assert html_response(conn, 200) =~ "cenius@cenius.ai"
    assert html_response(conn, 200) =~ "Demo"
  end

  test "POST /login with valid credentials redirects to /files", %{conn: conn, user: _user} do
    conn = post(conn, "/login", %{
      "email" => "cenius@cenius.ai",
      "password" => "cenius"
    })

    assert redirected_to(conn) == "/files"
    assert get_session(conn, :user_id)
  end

  test "POST /login with invalid credentials shows error", %{conn: conn} do
    conn = post(conn, "/login", %{
      "email" => "cenius@cenius.ai",
      "password" => "wrongpassword"
    })

    assert html_response(conn, 200) =~ "Invalid email or password"
  end

  test "GET / redirects to login when not authenticated", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn) == "/login"
  end
end

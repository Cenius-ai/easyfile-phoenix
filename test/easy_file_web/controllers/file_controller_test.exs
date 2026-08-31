defmodule EasyFileWeb.FileControllerTest do
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

    # Create a test uploads directory
    uploads_dir = Path.join(:code.priv_dir(:easy_file), "static/uploads")
    File.mkdir_p!(uploads_dir)

    {:ok, user: user}
  end

  defp login(conn, _user) do
    post(conn, "/login", %{
      "email" => "cenius@cenius.ai",
      "password" => "cenius"
    })
  end

  test "GET /files shows file list when authenticated", %{conn: conn, user: user} do
    conn = login(conn, user)
    conn = get(conn, "/files")
    assert html_response(conn, 200) =~ "Your Files"
  end

  test "GET /files requires authentication", %{conn: conn} do
    conn = get(conn, "/files")
    assert redirected_to(conn) == "/login"
  end

  test "GET /files/new shows upload form when authenticated", %{conn: conn, user: user} do
    conn = login(conn, user)
    conn = get(conn, "/files/new")
    assert html_response(conn, 200) =~ "Upload a File"
  end

  test "GET /files/new requires authentication", %{conn: conn} do
    conn = get(conn, "/files/new")
    assert redirected_to(conn) == "/login"
  end

  test "GET /logout clears session and redirects", %{conn: conn, user: user} do
    conn = login(conn, user)
    conn = get(conn, "/logout")
    assert redirected_to(conn) == "/login"
    refute get_session(conn, :user_id)
  end
end

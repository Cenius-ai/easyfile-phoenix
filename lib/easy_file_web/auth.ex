defmodule EasyFileWeb.Auth do
  import Plug.Conn, only: [get_session: 2, put_session: 3, delete_session: 2, configure_session: 2, halt: 1, assign: 3]
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  @doc """
  Logs the user in by putting their user_id into the session.
  """
  def login(conn, user) do
    conn
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  @doc """
  Logs the user out by clearing the session.
  """
  def logout(conn) do
    conn
    |> delete_session(:user_id)
  end

  # --- Plug callbacks for fetch_current_user ---

  def init(opts), do: opts

  def call(conn, :fetch_current_user) do
    fetch_current_user(conn)
  end

  def call(conn, :require_authenticated_user) do
    require_authenticated_user(conn)
  end

  def call(conn, :redirect_if_authenticated) do
    redirect_if_authenticated(conn)
  end

  # --- Internal ---

  defp fetch_current_user(conn) do
    user_id = get_session(conn, :user_id)

    if user_id do
      user = EasyFile.Accounts.get_user!(user_id)
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end

  defp require_authenticated_user(conn) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  defp redirect_if_authenticated(conn) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/files")
      |> halt()
    else
      conn
    end
  end
end

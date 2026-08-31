defmodule EasyFileWeb.FileController do
  use EasyFileWeb, :controller

  alias EasyFile.Uploads

  def index(conn, _params) do
    user = conn.assigns.current_user
    uploads = Uploads.list_uploads_for_user(user.id)

    render(conn, :index, uploads: uploads, user: user)
  end

  def new(conn, _params) do
    render(conn, :new, changeset: %{})
  end

  def create(conn, %{"upload" => %{"file" => file_upload}}) do
    user = conn.assigns.current_user

    case Uploads.save_upload(file_upload, user.id) do
      {:ok, upload} ->
        conn
        |> put_flash(:info, "File \"#{upload.filename}\" uploaded successfully.")
        |> redirect(to: "/files")

      {:error, reason} when is_binary(reason) ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/files/new")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to save file.")
        |> render(:new, changeset: changeset)
    end
  end
end

defmodule EasyFile.Uploads do
  import Ecto.Query, warn: false
  alias EasyFile.Repo
  alias EasyFile.Uploads.Upload

  @max_file_size 50 * 1024 * 1024
  @allowed_content_types [
    "image/jpeg",
    "image/png",
    "image/gif",
    "image/webp",
    "application/pdf",
    "text/plain",
    "text/csv",
    "application/zip",
    "application/json",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  ]
  @allowed_extensions [".jpg", ".jpeg", ".png", ".gif", ".webp", ".pdf", ".txt", ".csv", ".zip", ".json", ".doc", ".docx"]

  @doc """
  Returns the maximum allowed file size in bytes.
  """
  def max_file_size, do: @max_file_size

  @doc """
  Returns the list of allowed content types.
  """
  def allowed_content_types, do: @allowed_content_types

  @doc """
  Returns the list of allowed extensions.
  """
  def allowed_extensions, do: @allowed_extensions

  @doc """
  Lists all uploads for a given user, ordered by most recent first.
  """
  def list_uploads_for_user(user_id) do
    from(u in Upload, where: u.user_id == ^user_id, order_by: [desc: u.inserted_at])
    |> Repo.all()
  end

  @doc """
  Gets a single upload by id, scoped to the given user.
  """
  def get_upload!(id, user_id) do
    Repo.get_by!(Upload, id: id, user_id: user_id)
  end

  @doc """
  Creates an upload record.
  """
  def create_upload(attrs \\ %{}) do
    %Upload{}
    |> Upload.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the count of uploads for a user.
  """
  def count_uploads_for_user(user_id) do
    from(u in Upload, where: u.user_id == ^user_id)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Validates a file upload against allowed types, extensions, and size.
  Returns :ok or {:error, reason}.
  """
  def validate_upload(%Plug.Upload{} = upload) do
    ext = upload.filename |> Path.extname() |> String.downcase()
    file_size = get_upload_size(upload)

    cond do
      file_size > @max_file_size ->
        {:error, "File size exceeds the maximum allowed size of #{div(@max_file_size, 1_048_576)} MB"}

      ext not in @allowed_extensions ->
        {:error, "File type .#{ext} is not allowed. Allowed types: #{Enum.join(@allowed_extensions, ", ")}"}

      upload.content_type not in @allowed_content_types ->
        {:error, "Content type #{upload.content_type} is not allowed"}

      true ->
        :ok
    end
  end

  @doc """
  Saves an uploaded file to local disk and creates the database record.
  Returns {:ok, upload} or {:error, reason_or_changeset}.
  """
  def save_upload(%Plug.Upload{} = file_upload, user_id) do
    with :ok <- validate_upload(file_upload),
         {:ok, stored_path} <- store_file(file_upload) do

      file_size = get_upload_size(file_upload)

      attrs = %{
        filename: file_upload.filename,
        size: file_size,
        stored_path: stored_path,
        content_type: file_upload.content_type,
        user_id: user_id
      }

      create_upload(attrs)
    end
  end

  # Get the size of an uploaded file from the filesystem.
  defp get_upload_size(%Plug.Upload{} = upload) do
    case File.stat(upload.path) do
      {:ok, %{size: size}} -> size
      _ -> 0
    end
  end

  # Store a file to the uploads directory with a UUID-based filename.
  defp store_file(%Plug.Upload{} = upload) do
    uploads_dir = Path.join(:code.priv_dir(:easy_file), "static/uploads")
    File.mkdir_p!(uploads_dir)

    safe_ext = upload.filename |> Path.extname() |> String.downcase()
    uuid = Ecto.UUID.generate()
    stored_filename = "#{uuid}#{safe_ext}"
    dest_path = Path.join(uploads_dir, stored_filename)

    case File.cp(upload.path, dest_path) do
      :ok -> {:ok, stored_filename}
      {:error, reason} -> {:error, "Failed to save file: #{reason}"}
    end
  end
end

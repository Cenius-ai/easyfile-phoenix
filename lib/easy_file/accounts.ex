defmodule EasyFile.Accounts do
  import Ecto.Query, warn: false
  alias EasyFile.Repo
  alias EasyFile.Accounts.User

  @doc """
  Gets a user by email and password. Returns the user if credentials match, otherwise nil.
  """
  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    if user && Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  @doc """
  Gets a user by id.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the count of users.
  """
  def count_users, do: Repo.aggregate(User, :count, :id)
end

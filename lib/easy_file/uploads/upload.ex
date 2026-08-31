defmodule EasyFile.Uploads.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :filename, :string
    field :size, :integer
    field :stored_path, :string
    field :content_type, :string
    belongs_to :user, EasyFile.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:filename, :size, :stored_path, :content_type, :user_id])
    |> validate_required([:filename, :size, :stored_path, :content_type, :user_id])
    |> validate_number(:size, greater_than: 0)
    |> foreign_key_constraint(:user_id)
  end
end

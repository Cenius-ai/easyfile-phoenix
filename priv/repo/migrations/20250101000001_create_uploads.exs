defmodule EasyFile.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :filename, :string, null: false
      add :size, :integer, null: false
      add :stored_path, :string, null: false
      add :content_type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:uploads, [:user_id])
  end
end

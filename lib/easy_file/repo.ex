defmodule EasyFile.Repo do
  use Ecto.Repo,
    otp_app: :easy_file,
    adapter: Ecto.Adapters.SQLite3
end

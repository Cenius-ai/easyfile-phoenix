import Config

config :easy_file, EasyFileWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4001],
  server: false

config :easy_file, EasyFile.Repo,
  database: "priv/repo/easy_file_test.db"

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

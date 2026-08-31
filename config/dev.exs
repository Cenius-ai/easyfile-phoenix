import Config

config :easy_file, EasyFileWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  watchers: []

config :easy_file, EasyFile.Repo,
  database: "priv/repo/easy_file_dev.db"

config :easy_file, EasyFileWeb.Endpoint,
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*\.(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/easy_file_web/(controllers|components)/.*\.(ex|heex)$"
    ]
  ]

config :easy_file, dev_routes: true

config :logger, :default_formatter, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

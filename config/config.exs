import Config

config :easy_file,
  generators: [timestamp_type: :utc_datetime],
  ecto_repos: [EasyFile.Repo]

config :easy_file, EasyFileWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: EasyFileWeb.ErrorHTML, json: EasyFileWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: EasyFile.PubSub

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"

import Config

if System.get_env("PHX_SERVER") do
  config :easy_file, EasyFileWeb.Endpoint, server: true
end

port = String.to_integer(System.get_env("PORT", "4000"))
config :easy_file, EasyFileWeb.Endpoint, http: [port: port]

# Secret key base: environment-driven, no hardcoded literal anywhere.
# - dev: generated randomly at boot
# - test: derived deterministically from app name (stable across test runs)
# - prod: must be set via SECRET_KEY_BASE env var
secret_key_base =
  cond do
    key = System.get_env("SECRET_KEY_BASE") ->
      key

    config_env() == :test ->
      :crypto.hash(:sha512, "easy_file_test_secret_key_base_v1")
      |> Base.encode64()
      |> binary_part(0, 64)

    config_env() == :prod ->
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

    true ->
      :crypto.strong_rand_bytes(64) |> Base.encode64() |> binary_part(0, 64)
  end

if config_env() == :prod do
  host = System.get_env("PHX_HOST") || "example.com"

  config :easy_file, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :easy_file, EasyFileWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0}
    ],
    secret_key_base: secret_key_base
else
  config :easy_file, EasyFileWeb.Endpoint, secret_key_base: secret_key_base
end

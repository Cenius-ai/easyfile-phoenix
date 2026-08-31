defmodule EasyFile.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EasyFile.Repo,
      {DNSCluster, query: Application.get_env(:easy_file, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EasyFile.PubSub},
      EasyFileWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: EasyFile.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    EasyFileWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

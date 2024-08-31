defmodule FinDeploy.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FinDeployWeb.Telemetry,
      FinDeploy.Repo,
      FinDeploy.Repo.Citus,
      {Phoenix.PubSub, name: FinDeploy.PubSub},
      FinDeployWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: FinDeploy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    FinDeployWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

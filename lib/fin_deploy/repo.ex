defmodule FinDeploy.Repo do
  use Ecto.Repo,
    otp_app: :fin_deploy,
    adapter: Ecto.Adapters.Postgres
end

defmodule FinDeploy.Repo.Citus do
  use Ecto.Repo,
    otp_app: :fin_deploy,
    adapter: Ecto.Adapters.Postgres
end

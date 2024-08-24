defmodule FinDeployWeb.Router do
  use FinDeployWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FinDeployWeb do
    pipe_through :api
  end
end

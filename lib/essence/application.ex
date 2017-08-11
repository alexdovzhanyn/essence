defmodule Essence.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      worker(Essence.Router, []),
      supervisor(Essence.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Essence.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

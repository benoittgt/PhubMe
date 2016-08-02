defmodule PhubMe.Api do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(PhubMe.Web, [])
    ]

    opts = [strategy: :one_for_one, name: PhubMe.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

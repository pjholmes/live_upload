defmodule LiveUpload.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LiveUpload.Repo,
      # Start the Telemetry supervisor
      LiveUploadWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveUpload.PubSub},
      # Start the Endpoint (http/https)
      LiveUploadWeb.Endpoint
      # Start a worker by calling: LiveUpload.Worker.start_link(arg)
      # {LiveUpload.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveUpload.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LiveUploadWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Messages.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Messages.Repo,
      # Start the Telemetry supervisor
      MessagesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Messages.PubSub},
      # Start the Endpoint (http/https)
      MessagesWeb.Endpoint,
      # Start a worker by calling: Messages.Worker.start_link(arg)
      # {Messages.Worker, arg}
      {Messages.Slack, name: Messages.Slack}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Messages.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MessagesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

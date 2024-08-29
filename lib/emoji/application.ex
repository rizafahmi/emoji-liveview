defmodule Emoji.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EmojiWeb.Telemetry,
      Emoji.Repo,
      {DNSCluster, query: Application.get_env(:emoji, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Emoji.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Emoji.Finch},
      # Start a worker by calling: Emoji.Worker.start_link(arg)
      # {Emoji.Worker, arg},
      # Start to serve requests, typically the last entry
      EmojiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Emoji.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EmojiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

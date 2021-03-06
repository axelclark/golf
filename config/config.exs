# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :golf,
  ecto_repos: [Golf.Repo]

# Configures the endpoint
config :golf, GolfWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rfV4/ChXvgjdESftFfxa2eYeUuOkh0rlBzYH0VBCvUjaC2tzYziYIWidA1ssZVCo",
  render_errors: [view: GolfWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Golf.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Drab
config :drab, GolfWeb.Endpoint, otp_app: :golf

# Configures default Drab file extension
config :phoenix, :template_engines, drab: Drab.Live.Engine

# Configures Drab for webpack
config :drab, GolfWeb.Endpoint, js_socket_constructor: "window.__socket"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :golf, :pow,
  user: Golf.Accounts.User,
  repo: Golf.Repo,
  extensions: [PowResetPassword, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: GolfWeb.PowMailer,
  web_module: GolfWeb

config :golf, GolfWeb.PowMailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "${SENDGRID_API_KEY}"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

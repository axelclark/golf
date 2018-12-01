defmodule GolfWeb.Router do
  use GolfWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GolfWeb do
    pipe_through :browser

    resources "/courses", CourseController
    resources "/rounds", RoundController
    get "/", CourseController, :index
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug,
      schema: GolfWeb.Schema,
      json_codec: Jason

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: GolfWeb.Schema,
      interface: :simple,
      json_codec: Jason
  end
end

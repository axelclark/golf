defmodule GolfWeb.Resolvers.Accounts do
  import GolfWeb.Resolvers.ErrorHelpers
  alias Golf.Accounts
  alias GolfWeb.Router.Helpers, as: Routes
  alias PowResetPassword.Phoenix.Mailer

  @create_error "Couldn't register user."

  def create_user(_parent, %{input: params}, _resolution) do
    password = Map.get(params, :password)
    params = Map.put(params, :confirm_password, password)

    case Accounts.create_user(params) do
      {:error, changeset} ->
        error_response(@create_error, changeset)

      {:ok, user} ->
        token =
          GolfWeb.Authentication.sign(%{
            id: user.id
          })

        {:ok, %{token: token, user: user}}
    end
  end

  def create_reset_token(_parent, %{email: email_address}, _) do
    config = Application.get_env(:golf, :pow, [])
    conn = Pow.Plug.put_config(%Plug.Conn{}, config)
    params = %{"email" => email_address}

    conn
    |> PowResetPassword.Plug.create_reset_token(params)
    |> respond_create(email_address)
  end

  def login(_, %{email: email, password: password}, _) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        token =
          GolfWeb.Authentication.sign(%{
            id: user.id
          })

        {:ok, %{token: token, user: user}}

      _ ->
        {:error, "incorrect email or password"}
    end
  end

  ## Helpers

  ## create_reset_token

  defp respond_create({:ok, %{token: token, user: user}, conn}, email_address) do
    url =
      Routes.pow_reset_password_reset_password_url(
        GolfWeb.Endpoint,
        :edit,
        token
      )

    email = Mailer.reset_password(conn, user, url)
    Pow.Phoenix.Mailer.deliver(conn, email)

    {:ok, %{email: email_address}}
  end

  defp respond_create({:error, _, _}, email_address) do
    {:ok, %{email: email_address}}
  end
end

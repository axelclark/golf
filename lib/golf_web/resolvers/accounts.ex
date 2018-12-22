defmodule GolfWeb.Resolvers.Accounts do
  alias Golf.Accounts

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
end

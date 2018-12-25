defmodule GolfWeb.Resolvers.Accounts do
  alias Golf.Accounts

  def create_user(_parent, %{input: params}, _resolution) do
    password = Map.get(params, :password)
    params = Map.put(params, :confirm_password, password)

    case Accounts.create_user(params) do
      {:error, changeset} ->
        {
          :error,
          message: "Couldn't register user", details: error_details(changeset)
        }

      {:ok, user} ->
        token =
          GolfWeb.Authentication.sign(%{
            id: user.id
          })

        {:ok, %{token: token, user: user}}
    end
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

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end

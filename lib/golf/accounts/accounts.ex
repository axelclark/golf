defmodule Golf.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Golf.Repo
  alias Pow.Ecto.Schema.Password
  alias Golf.Accounts.User

  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    with %{password_hash: digest} <- user,
         true <- Password.pbkdf2_verify(password, digest) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.
  """
  def get_user!(id) do
    Repo.get!(User, id)
  end
end

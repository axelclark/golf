defmodule Golf.Accounts.User do
  use Ecto.Schema

  use Pow.Ecto.Schema,
    password_min_length: 6

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowPersistentSession]

  schema "users" do
    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end
end

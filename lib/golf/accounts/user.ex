defmodule Golf.Accounts.User do
  use Ecto.Schema

  use Pow.Ecto.Schema,
    password_min_length: 6

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowPersistentSession]

  @email_keys ["email", :email]

  schema "users" do
    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    attrs = Enum.reduce(@email_keys, attrs, &trim_email/2)

    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  ## Helpers

  ## changeset

  defp trim_email(key, attrs) do
    case Map.has_key?(attrs, key) do
      true ->
        Map.update!(attrs, key, &do_trim_email/1)

      false ->
        attrs
    end
  end

  defp do_trim_email(nil), do: nil

  defp do_trim_email(email), do: String.trim(email)
end

defmodule GolfWeb.Resolvers.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  def error_response(message, details) when is_binary(details) do
    {:error, message: message, details: details}
  end

  def error_response(message, changeset) do
    {:error, message: message, details: error_details(changeset)}
  end

  ## Helpers

  defp error_details(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &replace_keys_in_message/1)
  end

  defp replace_keys_in_message({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end

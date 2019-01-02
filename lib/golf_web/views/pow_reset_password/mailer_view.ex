defmodule GolfWeb.PowResetPassword.MailerView do
  use GolfWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end

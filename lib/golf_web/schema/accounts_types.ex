defmodule GolfWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  @desc "A user session"
  object :session do
    field :token, :string
    field :user, :user
  end

  @desc "A user"
  object :user do
    field :email, :string
    field :name, :string
  end
end

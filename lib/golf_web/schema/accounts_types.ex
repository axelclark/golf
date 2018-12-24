defmodule GolfWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  @desc "A user session"
  object :session do
    field :token, :string
    field :user, :user
  end

  @desc "A user"
  object :user do
    field :id, :id
    field :email, :string
    field :password_hash, :string
  end

  @desc "Inputs to create a user"
  input_object :user_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end
end

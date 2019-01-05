defmodule Golf.AccountsTest do
  use Golf.DataCase

  alias Golf.Accounts

  describe "users" do
    alias Golf.Accounts.User

    @user_attrs %{
      "email" => "user@example.com ",
      "password" => "password01",
      "confirm_password" => "password01"
    }
    test "strips trailing whitespace from email" do
      assert {:ok, %User{} = result} = Accounts.create_user(@user_attrs)
      assert result.email == "user@example.com"
    end

    @user_attrs %{
      email: "user@example.com ",
      password: "password01",
      confirm_password: "password01"
    }
    test "strips trailing whitespace from email with atom keys" do
      assert {:ok, %User{} = result} = Accounts.create_user(@user_attrs)
      assert result.email == "user@example.com"
    end
  end
end

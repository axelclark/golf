defmodule GolfWeb.Schema.Mutation.CreateUserTest do
  use GolfWeb.ConnCase

  @query """
  mutation ($user: UserInput!) {
    session: createUser(input: $user) {
      token
      user {
        id
        email
      }
    }
  }
  """
  test "createUser field creates a user", %{conn: conn} do
    email = "user@example.com"

    user_params = %{
      "email" => email,
      "password" => "Password1234"
    }

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"user" => user_params}

    assert %{
             "data" => %{
               "session" => %{
                 "user" => user_data,
                 "token" => token
               }
             }
           } = json_response(conn, 200)

    assert %{"email" => email, "id" => id} = user_data
    assert {:ok, %{id: String.to_integer(id)}} == GolfWeb.Authentication.verify(token)
  end

  test "createUser errors when password is too short", %{conn: conn} do
    user_params = %{
      "email" => "user@example.com",
      "password" => "TooShort"
    }

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"user" => user_params}

    assert json_response(conn, 200) == %{
             "data" => %{"session" => nil},
             "errors" => [
               %{
                 "details" => %{
                   "password" => ["should be at least %{count} character(s)"],
                   "password_hash" => ["can't be blank"]
                 },
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Couldn't register user.",
                 "path" => ["session"]
               }
             ]
           }
  end
end

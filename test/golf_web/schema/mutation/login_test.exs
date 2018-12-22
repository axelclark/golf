defmodule GolfWeb.Schema.Mutation.LoginTest do
  use GolfWeb.ConnCase, async: true

  @query """
  mutation ($email: String!, $password: String!) {
    login(email:$email, password: $password) {
      token
      user { email }
    }
  }
  """
  test "creating an user session" do
    password = "secret_password"
    user = insert_user(%{password: password, confirm_password: password})

    response =
      post(build_conn(), "/api", %{
        query: @query,
        variables: %{"email" => user.email, "password" => password}
      })

    assert %{
             "data" => %{
               "login" => %{
                 "token" => token,
                 "user" => user_data
               }
             }
           } = json_response(response, 200)

    assert %{"email" => user.email} == user_data
    assert {:ok, %{id: user.id}} == GolfWeb.Authentication.verify(token)
  end
end

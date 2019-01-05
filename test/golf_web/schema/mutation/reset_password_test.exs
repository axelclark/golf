defmodule GolfWeb.Schema.Mutation.ResetPasswordTest do
  use GolfWeb.ConnCase
  import Swoosh.TestAssertions

  @query """
  mutation ($email: String!) {
    user: resetPassword(email:$email) {
       email
    }
  }
  """
  test "resetPassword sends an email to reset a password", %{conn: conn} do
    email = "user@example.com"
    insert(:user, email: email)

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"email" => email}

    assert %{
             "data" => %{
               "user" => user_data
             }
           } = json_response(conn, 200)

    assert %{"email" => email} = user_data
    assert_email_sent()
  end

  test "resetPassword doesn't send email when user doesn't exist", %{conn: conn} do
    email = "user@example.com"

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"email" => email}

    assert %{
             "data" => %{
               "user" => user_data
             }
           } = json_response(conn, 200)

    assert %{"email" => email} = user_data
    refute_email_sent()
  end
end

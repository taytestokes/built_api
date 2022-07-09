defmodule BuiltApiWeb.AuthContollerTest do
  use BuiltApiWeb.ConnCase

  @test_user %{
    first_name: "Test",
    last_name: "User",
    email: "test@email.com",
    password: "testpassword"
  }

  describe "register" do
    test "creates a new user and returns the new user and the access token in the response and stores refresh token in the cookies",
         %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :register), user: @test_user)

      # Assert response includes user
      assert json_response(conn, 200)["user"]
      # Assert response includes access token
      assert json_response(conn, 200)["access_token"]
      # Assert response sets the refresh token to the cookies
      assert conn.cookies["refresh_token"]
    end
  end
end

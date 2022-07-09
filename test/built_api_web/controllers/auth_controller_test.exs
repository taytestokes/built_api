defmodule BuiltApiWeb.AuthContollerTest do
  use BuiltApiWeb.ConnCase

  alias BuiltApi.Repo
  alias BuiltApi.Schemas.User

  describe "register" do
    test "creates a new user and returns the new user and the access token in the response and stores refresh token in the cookies",
         %{conn: conn} do
      conn =
        post(conn, Routes.auth_path(conn, :register),
          user: %{
            first_name: "Test",
            last_name: "User",
            email: "test@email.com",
            password: "testpassword"
          }
        )

      # Assert response includes user
      assert json_response(conn, 200)["user"]
      # Assert response includes access token
      assert json_response(conn, 200)["access_token"]
      # Assert response sets the refresh token to the cookies
      assert conn.cookies["refresh_token"]
    end
  end

  describe "login" do
    test "signs a user in by setting a refresh token to the cookies and returning the user and access token in the response",
         %{conn: conn} do
        
      # Insert a user into the database authenticate as
      # TODO: Rethink about how to seed the test database using factories?
      post(conn, Routes.auth_path(conn, :register),
        user: %{
          first_name: "Test",
          last_name: "User",
          email: "test@email.com",
          password: "testpassword"
        }
      )

      # Make request to login action to authenticate
      conn =
        post(conn, Routes.auth_path(conn, :login),
          user: %{
            email: "test@email.com",
            password: "testpassword"
          }
        )

      # Assert response includes user
      assert json_response(conn, 200)["user"]
      # Assert response includes access token
      assert json_response(conn, 200)["access_token"]
      # Assert response sets the refresh token to the cookies
      assert conn.cookies["refresh_token"]
    end
  end
end

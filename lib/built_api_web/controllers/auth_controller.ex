defmodule BuiltApiWeb.AuthController do
    use BuiltApiWeb, :controller

    alias BuiltApi.Models.Users

    def register(conn, %{"user" => user_params}) do
        # case Users.create_user(user_params) do
        #     {:ok, user} -> 
        #     # If successful registration, sign the user in
        # end
    end

    def login(conn, %{"user" => user_params}) do
        # Create access token and and store it in the session
        # to act as authenticated
    end

    def signout(conn, _assigns) do
    end
end
defmodule BuiltApiWeb.UserController do
    use BuiltApiWeb, :controller

    alias BuiltApi.Models.Users

    def register(conn, %{"user" => user_params}) do
        case Users.create_user(user_params) do
            {:ok, user} -> 
                conn
                |> text("User has been created with the email #{user.email}")
        end
    end
end
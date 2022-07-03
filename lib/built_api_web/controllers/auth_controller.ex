defmodule BuiltApiWeb.AuthController do
    use BuiltApiWeb, :controller

    alias BuiltApi.Models.Users
    alias BuiltApi.Auth.Guardian

    def register(conn, %{"user" => user_params}) do
        case Users.create_user(user_params) do
            {:ok, user} -> 
                # Create access token
                {:ok, access_token, _claims} =
                    Guardian.encode_and_sign(user, %{}, token_type: "access")
                # Create refresh token
                {:ok, refresh_token, _claims} =
                    Guardian.encode_and_sign(user, %{}, token_type: "refresh")
                # Remove ecto data and return a map
                user = %{
                    id: user.id,
                    email: user.email
                }
                # Render the JSON view to send a response to the client
                render(conn, "register.json", user: user, access_token: access_token, refresh_token: refresh_token)
            
            {:error, %Ecto.Changeset{} = changeset} ->
                body = Jason.encode!(%{error: "User creation failed."})
                # Rethink error handling?
                conn
                |> send_resp(401, body)
        end
    end

    def login(conn, %{"user" => user_params}) do
        # Create access token and and store it in the session
        # to act as authenticated
    end

    def signout(conn, _assigns) do
        # Clears token stored in api memory - make sure to write logic to remove this shit on frontend
    end
end
defmodule BuiltApiWeb.AuthController do
    use BuiltApiWeb, :controller

    alias BuiltApi.Models.Users
    alias BuiltApi.Auth.Guardian

    def register(conn, %{"user" => user_params}) do
        case Users.create_user(user_params) do
            {:ok, user} -> 
                # Create access token
                {:ok, access_token, _claims} =
                    Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {1, :day})
                # Create refresh token
                {:ok, refresh_token, _claims} =
                    Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {7, :day})
                # Store refresh token in the response cookie
                # Render the JSON view to send a response to the client
                conn
                |> put_resp_cookie("ruid", refresh_token, http_only: true)
                |> render("register.json", user_id: user.id, user_email: user.email, access_token: access_token)
            
            {:error, %Ecto.Changeset{} = changeset} ->
                body = Jason.encode!(%{error: "User creation failed."})
                conn
                |> send_resp(401, body)
        end
    end

    def login(conn, %{"user" => user_params}) do
        case Users.get_by_email(user_params["email"]) do
            {:ok, user} ->
                # Create access token
                {:ok, access_token, _claims} =
                    Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {1, :day})
                # Create refresh token
                {:ok, refresh_token, _claims} =
                    Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {7, :day})
                
                conn
                |> put_resp_cookie("ruid", refresh_token, http_only: true)
                |> render("login.json", user_id: user.id, user_email: user.email, access_token: access_token)

            {:error, %Ecto.Changeset{} = changeset} ->
                body = Jason.encode!(%{error: "Authentication failed."})
                conn
                |> send_resp(401, body)
        end
    end

    # Refreshes the accessToken using the refreshToken stored in the httpOnly cookies
    # and it also retrieves the user resource that was was to encode the JWT and 
    # returns the user info back to the client
    def refresh_access_token(conn, _params) do
        refresh_token = Plug.Conn.fetch_cookies(conn) |> Map.from_struct() |> get_in([:cookies, "ruid"])
        {:ok, user, _claims} =
            Guardian.resource_from_token(refresh_token)

        case Guardian.exchange(refresh_token, "refresh", "access") do
            {:ok, _old_token, {new_access_token, _new_claims}} ->
                conn
                |> put_status(:created)
                |> render("refresh_access_token.json", user_id: user.id, user_email: user.email, access_token: new_access_token)

            {:error, reason} ->
                conn
                |> send_resp(401, reason)
        end
    end

    def signout(conn, _assigns) do
        body = Jason.encode!(%{message: "Successfully signed out."})
        # Clear the regresh token stored in cookies
        conn
        |> delete_resp_cookie("ruid")
        |> send_resp(200, body)
    end
end
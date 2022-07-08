defmodule BuiltApiWeb.AuthController do
  use BuiltApiWeb, :controller

  alias BuiltApi.Models.Users
  alias BuiltApi.Auth.Guardian

  def register(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        {:ok, access_token, _claims} =
          Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {1, :day})

        {:ok, refresh_token, _claims} =
          Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {7, :day})

        conn
        |> put_resp_cookie("refresh_token", refresh_token, http_only: true)
        |> render("register.json",
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          access_token: access_token
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        # WARNING: This only handles when there is one changeset error present
        # Will have to rethink this logic to handle multiple changeset errors
        error_message = handle_error_message(changeset.errors)
        # Send back a 500 status error with the error messages
        conn
        |> send_resp(500, Jason.encode!(%{error: error_message}))
        |> halt()
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
        |> put_resp_cookie("refresh_token", refresh_token, http_only: true)
        |> render("login.json",
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          access_token: access_token
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        error_message = handle_error_message(changeset.errors)
        # Send back a 500 status error with the error messages
        conn
        |> send_resp(500, Jason.encode!(%{error: error_message}))
        |> halt()
    end
  end

  # Refreshes the accessToken using the refreshToken stored in the httpOnly cookies
  # and it also retrieves the user resource that was was to encode the JWT and 
  # returns the user info back to the client
  def refresh_access_token(conn, _params) do
    refresh_token =
      Plug.Conn.fetch_cookies(conn) |> Map.from_struct() |> get_in([:cookies, "refresh_token"])

    {:ok, user, _claims} = Guardian.resource_from_token(refresh_token)

    case Guardian.exchange(refresh_token, "refresh", "access") do
      {:ok, _old_token, {access_token, _new_claims}} ->
        conn
        |> render("refresh_access_token.json",
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          access_token: access_token
        )

      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  def sign_out(conn, _assigns) do
    conn
    |> delete_resp_cookie("ruid")
    |> send_resp(200, "Successfully signed out!")
  end

  defp handle_error_message(errors) do
    Enum.reduce(errors, "", fn error, accum ->
      {field, {message, _reasons}} = error
      accum = "#{field} #{message}"
    end)
  end
end

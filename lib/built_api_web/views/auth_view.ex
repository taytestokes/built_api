defmodule BuiltApiWeb.AuthView do
  use BuiltApiWeb, :view

  # Sends a response for registering a new user
  def render("register.json", %{user_id: user_id, user_email: user_email, access_token: access_token}) do
    %{
      user_id: user_id,
      user_email: user_email,
      access_token: access_token,
    }
  end

  # Sends a response for ligging in a user
  def render("login.json", %{user_id: user_id, user_email: user_email, access_token: access_token}) do
    %{
      user_id: user_id,
      user_email: user_email,
      access_token: access_token,
    }
  end

  # Returns a new access token created from exchanging a valid refresh token
  def render("refresh_access_token.json", %{user_id: user_id, user_email: user_email, access_token: access_token}) do
    %{
      user_id: user_id,
      user_email: user_email,
      access_token: access_token,
    }
  end
end

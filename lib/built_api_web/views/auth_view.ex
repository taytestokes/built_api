defmodule BuiltApiWeb.AuthView do
  use BuiltApiWeb, :view

  # Sends a response for registering a new user
  def render("register.json", %{
        id: id,
        first_name: first_name,
        last_name: last_name,
        email: email,
        access_token: access_token
      }) do
    %{
      user: %{
        id: id,
        first_name: first_name,
        last_name: last_name,
        email: email
      },
      access_token: access_token
    }
  end

  # Sends a response for ligging in a user
  def render("login.json", %{
        id: id,
        first_name: first_name,
        last_name: last_name,
        email: email,
        access_token: access_token
      }) do
    %{
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      access_token: access_token
    }
  end

  # Returns a new access token created from exchanging a valid refresh token
  def render("refresh_access_token.json", %{
        id: id,
        first_name: first_name,
        last_name: last_name,
        email: email,
        access_token: access_token
      }) do
    %{
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      access_token: access_token
    }
  end
end

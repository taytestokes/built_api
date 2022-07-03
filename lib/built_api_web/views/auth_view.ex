defmodule BuiltApiWeb.AuthView do
  use BuiltApiWeb, :view

  # Sends a response for registering a new user
  def render("register.json", %{user: user, access_token: access_token, refresh_token: refresh_token}) do
    %{
      user: user,
      access_token: access_token,
      refresh_token: refresh_token
    }
  end
end

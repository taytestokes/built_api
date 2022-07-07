# Custom plug to handle errors for Guardian
# when trying to authenticate access tokens
defmodule BuiltApi.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})

    # Since this is a JSON based API, we will return
    # JSON data for the error instead of plain text
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end

# Custom pipeline that will be used in the router for HTTP requests so the guardian implementation module can watch for session or header the jwt tokens used for authentication
defmodule BuiltApi.Auth.Pipeline do
    use Guardian.Plug.Pipeline,
        otp_app: :built_api,
        module: BuiltApi.Auth.Guardian,
        error_handler: BuiltApi.Auth.ErrorHandler
    
    # If there is a session token, restrict it to an access token and validate it
    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}, realm: "Bearer"
    # If there is a header token, restrict it to an access token and validate it
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, realm: "Bearer"
    # Load the user if either verifcation has worked
    plug Guardian.Plug.LoadResource
end
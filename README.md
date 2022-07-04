# BuiltApi

## Authentication

The Built API used Guardian to handle JWT token badsed authentication.

The value for the `secret_key` being used in the configuration can be generated from running the `mix guardian.gen.secret` mix task.

## CORS

This API utilizes cors_plug to handle CORS (Cross Origin Resource Sharing) requests. Basically, it allows the React client to talk to the API.

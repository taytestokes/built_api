# BuiltApi

## Authentication

The Built API used Guardian to handle JWT token badsed authentication.

The value for the `secret_key` being used in the configuration can be generated from running the `mix guardian.gen.secret` mix task.

## CORS

This API utilizes Corsica to handle CORS (Cross Origin Resource Sharing) requests. Basically, it allows the React client to talk to the API. A custom plug is created to configure the allowed response headers.

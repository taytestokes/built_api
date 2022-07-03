defmodule BuiltApi.Models.Users do
    alias BuiltApi.Repo
    alias BuiltApi.Schemas.User

    # Creates a new user struct from the user ecto schema
    # and validates it against the registration changeset
    # and inserts the new user into the database if valid
    def create_user(attrs) do
        %User{}
        |> User.registration_changeset(attrs)
        |> Repo.insert()
    end
end
defmodule BuiltApi.Models.Users do
    import Ecto.Query

    alias BuiltApi.Repo
    alias BuiltApi.Schemas.User

    # Queries the database to find a user by
    # their id
    def get_by_id!(id) do 
        Repo.get!(User, id) 
    end

    # Queries the database to get a user by email
    def get_by_email(email) do
        email = String.downcase(email)
        query = from(
            u in User,
            where: u.email == ^email
        )

        case Repo.one(query) do
            nil -> {:error, :not_found}
            user -> {:ok, user}
        end
    end

    # Creates a new user struct from the user ecto schema
    # and validates it against the registration changeset
    # and inserts the new user into the database if valid
    def create_user(attrs) do
        %User{}
        |> User.registration_changeset(attrs)
        |> Repo.insert()
    end

    # Queries the database for the user, if the user is found
    # we verify the password that has been given matches the
    # hashed password on the user after hashing the given password.
    # If password matches, we return the error
    # If password doesn't match, we return an error
    # If no user, we return an error
    def authenticate_user(email, password) do
        user = get_by_email(email)

        cond do
            user && Argon2.verify_pass(password, user.password_hash) ->
                {:ok, user}
            user ->
                {:error, :bad_password}
            true ->
                {:error, :bad_email}
        end
    end
end
# This is the implementation module for Guardian that
# will be used for JWT token based authentication
defmodule BuiltApi.Auth.Guardian do
    use Guardian, otp_app: :built_api 

    alias BuiltApi.Models.Users

    # subject_for_token is used to code the user
    # into the subject of the jwt token
    def subject_for_token(user, _claims) do
        {:ok, to_string(user.id)}
    end

    # resource_from_claims extracts the user id from the
    # stored user in the token subject
    def resource_from_claims(claims) do
        user = Users.get_by_id!(claims["sub"])
        {:ok, user}
    rescue
        Ecto.NoResultsError -> {:error, :resource_not_found}
    end
end
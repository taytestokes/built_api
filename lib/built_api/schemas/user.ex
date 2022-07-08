defmodule BuiltApi.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  # Creates an ecto based user struct that can be 
  # passed to changesets for validation and then
  # gets inserted into the database
  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps()
  end

  # Changeset used to validate the user struct
  # upon registration before inserting the data
  # into the database
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password])
    |> validate_required([:first_name, :last_name, :email, :password])
    |> down_case_email()
    |> down_case_first_name()
    |> down_case_last_name()
    |> unique_constraint(:email)
    |> hash_password()
  end

  # Uses the Argon2 module to hash the user password
  # and make a put_change on the changeset to update the
  # password_hash field to the value of the hashed and salted
  # password from the virtual password field
  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  defp down_case_email(changeset) do
    case get_field(changeset, :email) do
      nil -> changeset
      email -> put_change(changeset, :email, String.downcase(email))
    end
  end

  defp down_case_first_name(changeset) do
    case get_field(changeset, :first_name) do
      nil -> changeset
      first_name -> put_change(changeset, :first_name, String.downcase(first_name))
    end
  end

  defp down_case_last_name(changeset) do
    case get_field(changeset, :last_name) do
      nil -> changeset
      last_name -> put_change(changeset, :last_name, String.downcase(last_name))
    end
  end
end

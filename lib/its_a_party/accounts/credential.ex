defmodule ItsAParty.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias ItsAParty.Accounts.{Credential, User}

  schema "credentials" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    belongs_to :user, User

    timestamps()
  end

  @fields ~w(email password password_confirmation)a
  @required_fields ~w(email password password_confirmation)a

  @doc false
  def changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 6)
    |> validate_length(:password_confirmation, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_in_token()
  end

  defp put_password_in_token(changeset) do
    Ecto.Changeset.put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(changeset.params["password"]))
  end
end

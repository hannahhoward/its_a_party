defmodule ItsAParty.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ItsAParty.Accounts.{User, Credential}


  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :roles, {:array, :string}, default: []
    has_one :credential, Credential
    
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :roles])
    |> validate_required([:first_name, :last_name, :roles])
  end
end

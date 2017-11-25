defmodule ItsAParty.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ItsAParty.Accounts.User


  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :roles, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :roles])
    |> validate_required([:first_name, :last_name, :roles])
  end
end

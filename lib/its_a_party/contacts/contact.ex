defmodule ItsAParty.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias ItsAParty.Contacts.{Owner, Contact}

  schema "contacts" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:phone_number, :string)
    belongs_to(:owner, Owner)

    timestamps()
  end

  @doc false
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, [:first_name, :last_name, :email, :phone_number])
    |> validate_required([:first_name, :last_name, :email, :phone_number])
  end
end
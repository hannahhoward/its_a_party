defmodule ItsAParty.Contacts.Owner do
  use Ecto.Schema
  import Ecto.Changeset
  alias ItsAParty.Contacts.{Contact, Owner}

  schema "contact_owners" do
    has_many(:contacts, Contact)
    belongs_to(:user, ItsAParty.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(%Owner{} = owner, attrs) do
    owner
    |> cast(attrs, [])
    |> validate_required([])
  end
end
defmodule ItsAParty.Contacts.ContactsImpl do
  @moduledoc """
  The Contacts context - implementation
  """
  @behaviour ItsAParty.Contacts
  import Ecto.Query, warn: false
  alias ItsAParty.Repo

  alias ItsAParty.Contacts.{Contact, Owner}

  @impl true
  def list_owner_contacts(%Owner{} = owner) do
    query = Contact |> where(owner_id: ^owner.id)

    Repo.all(query)
    |> Repo.preload(owner: [user: :credential])
  end

  @impl true
  def get_contact!(id) do
    Repo.get!(Contact, id)
    |> Repo.preload(owner: [user: :credential])
  end

  @impl true
  def create_contact(%Owner{} = owner, attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Ecto.Changeset.put_change(:owner_id, owner.id)
    |> Repo.insert()
  end

  @impl true
  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @impl true
  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  @impl true
  def change_contact(%Contact{} = contact) do
    Contact.changeset(contact, %{})
  end

  @impl true
  def get_owner!(id) do
    Repo.get!(Owner, id)
    |> Repo.preload(user: :credential)
  end

  @impl true
  def ensure_owner_exists(%ItsAParty.Accounts.User{} = user) do
    %Owner{user_id: user.id}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.unique_constraint(:user_id)
    |> Repo.insert()
    |> handle_existing_owner()
  end

  @spec handle_existing_owner({:ok, %Owner{}} | {:error, %Ecto.Changeset{}}) :: %Owner{}
  defp handle_existing_owner({:ok, %Owner{} = owner}), do: owner

  defp handle_existing_owner({:error, %Ecto.Changeset{} = changeset}) do
    Repo.get_by!(Owner, user_id: changeset.data.user_id)
  end
end
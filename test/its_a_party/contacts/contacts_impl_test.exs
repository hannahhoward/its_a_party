defmodule ItsAParty.ContactsImplTest do
  use ItsAParty.DataCase

  alias ItsAParty.Contacts.ContactsImpl, as: Contacts
  import ItsAParty.Factory

  describe "contacts" do
    alias ItsAParty.Contacts.Contact

    @valid_attrs %{
      email: "some email",
      first_name: "some first_name",
      last_name: "some last_name",
      phone_number: "some phone_number"
    }
    @update_attrs %{
      email: "some updated email",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      phone_number: "some updated phone_number"
    }
    @invalid_attrs %{
      email: nil,
      first_name: nil,
      last_name: nil,
      phone_number: nil
    }

    def contact_fixture(owner \\ insert(:owner), attrs \\ %{}) do
      {:ok, contact} =
        Contacts.create_contact(
          owner,
          attrs
          |> Enum.into(@valid_attrs)
        )

      Contacts.get_contact!(contact.id)
    end

    test "list_owner_contacts/1 returns all contacts for an owner" do
      owner = insert(:owner)
      contact = contact_fixture(owner)
      assert Contacts.list_owner_contacts(owner) == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Contacts.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Contacts.create_contact(insert(:owner), @valid_attrs)
      assert contact.email == "some email"
      assert contact.first_name == "some first_name"
      assert contact.last_name == "some last_name"
      assert contact.phone_number == "some phone_number"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_contact(insert(:owner), @invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, contact} = Contacts.update_contact(contact, @update_attrs)
      assert %Contact{} = contact
      assert contact.email == "some updated email"
      assert contact.first_name == "some updated first_name"
      assert contact.last_name == "some updated last_name"
      assert contact.phone_number == "some updated phone_number"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_contact(contact, @invalid_attrs)
      assert contact == Contacts.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Contacts.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Contacts.change_contact(contact)
    end
  end

  describe "contact_owners" do
    alias ItsAParty.Contacts.Owner

    @valid_attrs %{user: build(:user)}
    @update_attrs %{}
    @invalid_attrs %{}

    def owner_fixture(user \\ insert(:user)) do
      owner = Contacts.ensure_owner_exists(user)

      Contacts.get_owner!(owner.id)
    end

    test "get_owner!/1 returns the owner with given id" do
      owner = owner_fixture()
      assert Contacts.get_owner!(owner.id) == owner
    end

    test "ensure_owner_exists/1 with a user with no owner" do
      assert (%Owner{} = owner) = Contacts.ensure_owner_exists(insert(:user))
    end

    test "ensure_owner_exists/1 with a user with an existing owner does not generate a new owner" do
      owner = owner_fixture()
      assert owner.user_id == Contacts.ensure_owner_exists(owner.user).user_id
    end
  end
end
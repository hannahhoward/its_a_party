defmodule ItsAPartyWeb.ContactControllerTest do
  use ItsAPartyWeb.ConnCase
  alias ItsAParty.ContactsMock
  alias ItsAParty.Contacts.Contact
  alias ItsAParty.Contacts.Owner
  alias ItsAParty.Accounts.User
  import ItsAPartyWeb.LoginHelpers
  import Mox

  @contact_attrs %{}
  @owner_id 4
  @other_owner_id 7

  setup do
    ContactsMock
    |> stub(:ensure_owner_exists, fn %User{id: user_id} ->
         %Owner{id: @owner_id, user_id: user_id}
       end)

    :ok
  end

  setup :verify_on_exit!

  describe "index" do
    test "when not logged in redirects to login", %{conn: conn} do
      conn = get(conn, contact_path(conn, :index))
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in lists current users contacts", %{conn: conn} do
      ContactsMock
      |> expect(:list_owner_contacts, fn %Owner{user_id: 1} ->
           [%Contact{id: 1}, %Contact{id: 2}]
         end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> get(contact_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Contacts"
    end
  end

  describe "new contact" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = get(conn, contact_path(conn, :new))
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in renders form", %{conn: conn} do
      ContactsMock
      |> expect(:change_contact, fn _ -> Contact.changeset(%Contact{}, %{}) end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> get(contact_path(conn, :new))

      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "create contact" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = post(conn, contact_path(conn, :create), contact: @contact_attrs)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in redirects to show when data is valid", %{conn: conn} do
      ContactsMock
      |> expect(:create_contact, fn %Owner{user_id: 1}, _ -> {:ok, %Contact{id: 1}} end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> post(contact_path(conn, :create), contact: @contact_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == contact_path(conn, :show, id)
    end

    test "when logged in renders errors when data is invalid", %{conn: conn} do
      ContactsMock
      |> expect(:create_contact, fn %Owner{user_id: 1}, _ ->
           {:error, Contact.changeset(%Contact{}, %{})}
         end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> post(contact_path(conn, :create), contact: @contact_attrs)

      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "edit contact" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = get(conn, contact_path(conn, :edit, %Contact{id: 1}))
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in renders form for editing chosen contact if owner owns contact", %{
      conn: conn
    } do
      ContactsMock
      |> expect(:change_contact, fn c -> Contact.changeset(c, %{}) end)
      |> expect(:get_contact!, fn id -> %Contact{id: id, owner_id: @owner_id} end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> get(contact_path(conn, :edit, %Contact{id: 1}))

      assert html_response(conn, 200) =~ "Edit Contact"
    end

    test "when logged in it redirects if owner does not own contact", %{conn: conn} do
      ContactsMock
      |> expect(:get_contact!, fn id -> %Contact{id: id, owner_id: @other_owner_id} end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> get(contact_path(conn, :edit, %Contact{id: 1}))

      assert redirected_to(conn) == contact_path(conn, :index)
    end
  end

  describe "update contact" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = put(conn, contact_path(conn, :update, %Contact{id: 1}), contact: @contact_attrs)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in it redirects if owner does not own contact", %{conn: conn} do
      ContactsMock
      |> expect(:get_contact!, fn id -> %Contact{id: id, owner_id: @other_owner_id} end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> put(contact_path(conn, :update, %Contact{id: 1}), contact: @contact_attrs)

      assert redirected_to(conn) == contact_path(conn, :index)
    end

    test "when logged in redirects when data is valid if owner owns contact", %{conn: conn} do
      ContactsMock
      |> expect(:update_contact, fn c, _params -> {:ok, c} end)
      |> expect(:get_contact!, fn id -> %Contact{id: id, owner_id: @owner_id} end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> put(contact_path(conn, :update, %Contact{id: 1}), contact: @contact_attrs)

      assert redirected_to(conn) == contact_path(conn, :show, %Contact{id: 1})
    end

    test "when logged in renders errors when data is invalid if owner owns contact", %{conn: conn} do
      ContactsMock
      |> expect(:update_contact, fn c, params -> {:error, Contact.changeset(c, params)} end)
      |> expect(:get_contact!, fn id -> %Contact{id: id, owner_id: @owner_id} end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> put(contact_path(conn, :update, %Contact{id: 1}), contact: @contact_attrs)

      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "delete contact" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = delete(conn, contact_path(conn, :delete, %Contact{id: 1}))
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in it redirects if owner does not own contact", %{conn: conn} do
      ContactsMock
      |> expect(:get_contact!, fn id -> %Contact{id: id, owner_id: @other_owner_id} end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> delete(contact_path(conn, :delete, %Contact{id: 1}))

      assert redirected_to(conn) == contact_path(conn, :index)
    end

    test "when logged in and logged in user owns contact deletes chosen contact", %{conn: conn} do
      ContactsMock
      |> expect(:delete_contact, fn c -> {:ok, c} end)
      |> expect(:get_contact!, fn id -> %Contact{id: id, owner_id: @owner_id} end)

      conn =
        conn
        |> sign_in_as_non_admin
        |> delete(contact_path(conn, :delete, %Contact{id: 1}))

      assert redirected_to(conn) == contact_path(conn, :index)
    end
  end
end
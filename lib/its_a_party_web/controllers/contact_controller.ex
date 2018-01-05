defmodule ItsAPartyWeb.ContactController do
  use ItsAPartyWeb, :controller

  @contacts Application.get_env(:its_a_party, :contacts)

  alias ItsAParty.Contacts.Contact

  plug(ItsAPartyWeb.Plugs.AuthorizeUser)
  plug(:require_existing_owner)
  plug(:authorize_contact when action in [:show, :edit, :update, :delete])

  def index(conn, _params) do
    contacts = @contacts.list_owner_contacts(conn.assigns.current_owner)
    render(conn, "index.html", contacts: contacts)
  end

  def new(conn, _params) do
    changeset = @contacts.change_contact(%Contact{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"contact" => contact_params}) do
    case @contacts.create_contact(conn.assigns.current_owner, contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact created successfully.")
        |> redirect(to: contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    render(conn, "show.html")
  end

  def edit(conn, _) do
    changeset = @contacts.change_contact(conn.assigns.contact)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"contact" => contact_params}) do
    case @contacts.update_contact(conn.assigns.contact, contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact updated successfully.")
        |> redirect(to: contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _contact} = @contacts.delete_contact(conn.assigns.contact)

    conn
    |> put_flash(:info, "Contact deleted successfully.")
    |> redirect(to: contact_path(conn, :index))
  end

  defp require_existing_owner(conn, _) do
    owner = @contacts.ensure_owner_exists(conn.assigns.current_user)
    assign(conn, :current_owner, owner)
  end

  defp authorize_contact(conn, _) do
    contact = @contacts.get_contact!(conn.params["id"])

    if conn.assigns.current_owner.id == contact.owner_id do
      assign(conn, :contact, contact)
    else
      conn
      |> put_flash(:error, "You can't modify that contact")
      |> redirect(to: contact_path(conn, :index))
      |> halt()
    end
  end
end
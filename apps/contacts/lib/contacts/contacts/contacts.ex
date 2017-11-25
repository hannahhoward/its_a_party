defmodule Contacts.Contacts do
  @moduledoc """
  The Contacts context.
  """

  @type id :: String.t
  @type owner_id :: String.t

  alias Contacts.Contacts.Contact

  @doc """
  Return list of contacts from a given list of contact ids

  ## Examples

      iex> get_by_ids([id1, id2])
      [%Contact{id: id1}, ...]

  """
  @callback get_by_ids([id]) :: {:ok, [%Contact{}]} | {:error, String.t }

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_contact!(id) :: {:ok, %Contact{}} | {:error, String.t }
  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_contacts(owner_id, [Map.t]) :: {:ok, [%Contact{}]} | {:error, %Ecto.Changeset{}}
  @doc """
  Updates a contact.

  ## Examples

      iex> update_contact(contact, %{field: new_value})
      {:ok, %Contact{}}

      iex> update_contact(contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_contacts([Map.t]) :: {:ok, [%Contact{}]} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a Contact.

  ## Examples

      iex> delete_contact(contact)
      {:ok, %Contact{}}

      iex> delete_contact(contact)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_contact(%Contact{}) :: {:ok, %Contact{}} | {:error, %Ecto.Changeset{}}
end

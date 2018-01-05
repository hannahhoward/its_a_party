defmodule ItsAParty.Contacts do
  @moduledoc """
  The Contacts context.
  """

  alias ItsAParty.Contacts.{Owner, Contact}

  @doc """
  Returns the list of contacts for the given owner

  ## Examples

      iex> list_owner_contacts(owner)
      [%Contact{}, ...]

  """
  @callback list_owner_contacts(%Owner{}) :: [%Contact{}]

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_contact!(id :: term) :: %Contact{}

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(owner, %{field: value})
      {:ok, %Contact{}}

      iex> create_contact(owner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_contact(%Owner{}) :: {:ok, %Contact{}} | {:error, %Ecto.Changeset{}}
  @callback create_contact(%Owner{}, attrs :: %{}) ::
              {:ok, %Contact{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a contact.

  ## Examples

      iex> update_contact(contact, %{field: new_value})
      {:ok, %Contact{}}

      iex> update_contact(contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_contact(contact :: %Contact{}, attrs :: %{}) ::
              {:ok, %Contact{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a Contact.

  ## Examples

      iex> delete_contact(contact)
      {:ok, %Contact{}}

      iex> delete_contact(contact)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_contact(contact :: %Contact{}) ::
              {:ok, %Contact{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> change_contact(contact)
      %Ecto.Changeset{source: %Contact{}}

  """
  @callback change_contact(contact :: %Contact{}) :: %Ecto.Changeset{}

  @doc """
  Gets a single owner.

  Raises `Ecto.NoResultsError` if the Owner does not exist.

  ## Examples

      iex> get_owner!(123)
      %Owner{}

      iex> get_owner!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_owner!(id :: term) :: %Owner{}

  @doc """
  Given a user, return their respective contact owner record or create one

  ## Examples

      iex> ensure_owner_exists(%User{id: 1})
      %Owner{user_id: 1}
  """
  @callback ensure_owner_exists(%ItsAParty.Accounts.User{}) :: %Owner{}
end
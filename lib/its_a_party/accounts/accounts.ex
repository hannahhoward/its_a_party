defmodule ItsAParty.Accounts do
  alias ItsAParty.Accounts.User

  @moduledoc """
  The Accounts context.
  """

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @callback list_users() :: [%User{}]

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @callback get_user!(id :: term) :: %User{} | nil | no_return

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback create_user() :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  @callback create_user(attrs :: Map.t()) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @callback update_user(user :: %User{}, attrs :: Map.t()) ::
              {:ok, %User{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @callback delete_user(user :: %User{}) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  @callback change_user(user :: %User{}) :: %Ecto.Changeset{}

  @doc """
  Verifies a User by email and password credentials

  ## Examples

      iex> authenticate_by_email_and_password(email, password)
      {:ok, %User{}}

      iex> authenticate_by_email_and_password(email, password)
      {:error, :not_found }

      iex> authenticate_by_email_and_password(email, password)
      {:error, :unauthorized }

  """
  @callback authenticate_by_email_and_password(email :: String.t(), password :: String.t()) ::
              {:ok, %User{}} | {:error, :not_found} | {:error, :unauthorized}

  @doc """
  Verifies if a user is an admin

  ## Examples

      iex> is_admin?(user_who_has_admin_role)
      true

      iex> is_admin?(user_who_does_not_have_admin_role)
      false
  """
  @callback is_admin?(user :: %User{}) :: true | false
end
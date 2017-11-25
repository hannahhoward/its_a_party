defmodule ItsAParty.Accounts.AccountsImpl do
  @behaviour ItsAParty.Accounts

  @moduledoc """
  The Accounts context -- Implementation
  """

  import Ecto.Query, warn: false
  alias ItsAParty.Repo

  alias ItsAParty.Accounts.{User, Credential}

  @impl true
  def list_users do
    Repo.all(User)
    |> Repo.preload(:credential)
  end

  @impl true
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:credential)
  end

  @impl true
  def create_user(attrs \\ %{}) do
    %User{roles: []}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, required: true, with: &Credential.changeset/2)
    |> Repo.insert()
  end

  @impl true
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.update()
  end

  @impl true
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @impl true
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @impl true
  def authenticate_by_email_and_password(email, _password) when is_nil(email) do
    {:error, :not_found}
  end

  def authenticate_by_email_and_password(email, password) do
    query =
      from(
        u in User,
        inner_join: c in assoc(u, :credential),
        where: c.email == ^email
      )

    case Repo.one(query) do
      %User{} = user -> verify_user_password(user |> Repo.preload(:credential), password)
      nil -> {:error, :not_found}
    end
  end

  @spec verify_user_password(user :: %User{}, password :: String.t()) ::
          {:ok, %User{}} | {:error, :unauthorized}
  defp verify_user_password(user, password) do
    cond do
      Comeonin.Bcrypt.checkpw(password, user.credential.encrypted_password) -> {:ok, user}
      true -> {:error, :unauthorized}
    end
  end
end
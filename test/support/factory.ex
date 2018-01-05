defmodule ItsAParty.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: ItsAParty.Repo

  def user_factory do
    %ItsAParty.Accounts.User{
      first_name: "Jane",
      last_name: "Smith",
      roles: [],
      credential: build(:credential) |> set_password("password12")
    }
  end

  def credential_factory do
    %ItsAParty.Accounts.Credential{
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def set_password(%ItsAParty.Accounts.Credential{} = credential, password) do
    credential
    |> ItsAParty.Accounts.Credential.changeset(%{
         password: password,
         password_confirmation: password
       })
    |> Ecto.Changeset.apply_changes()
  end

  def owner_factory do
    %ItsAParty.Contacts.Owner{
      user: build(:user)
    }
  end

  def contact_factory do
    %ItsAParty.Contacts.Contact{
      first_name: "Jane",
      last_name: "Smith",
      phone_number: sequence(:phone_number, &"213867530-#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end
end
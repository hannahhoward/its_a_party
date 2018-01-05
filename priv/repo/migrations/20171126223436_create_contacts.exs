defmodule ItsAParty.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:email, :string)
      add(:phone_number, :string)
      timestamps()
    end
  end
end
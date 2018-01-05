defmodule ItsAParty.Repo.Migrations.CreateContactOwners do
  use Ecto.Migration

  def change do
    create table(:contact_owners) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(unique_index(:contact_owners, [:user_id]))
  end
end
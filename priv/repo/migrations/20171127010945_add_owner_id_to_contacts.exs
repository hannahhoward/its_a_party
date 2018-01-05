defmodule ItsAParty.Repo.Migrations.AddOwnerIdToContacts do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add(:owner_id, references(:contact_owners, on_delete: :delete_all), null: false)
    end

    create(index(:contacts, [:owner_id]))
  end
end
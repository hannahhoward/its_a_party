defmodule ItsAParty.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :email, :string
      add :encrypted_password, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:credentials, [:email])
    create index(:credentials, [:user_id])
  end
end

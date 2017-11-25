defmodule ItsAParty.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :roles, {:array, :string}

      timestamps()
    end

  end
end

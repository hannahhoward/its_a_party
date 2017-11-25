defmodule ContactsApi.Schema do
  use Absinthe.Schema

  import_types(__MODULE__.ContactTypes)

  query do
    field :contacts, list_of(:contact) do
      arg :ids
      arg :owner_id
    end
  end

end
defmodule ItsAPartyWeb.LoginHelpers do
  alias ItsAParty.AccountsMock
  alias ItsAParty.Accounts.User
  import Mox
  import Plug.Test

  def sign_in(conn, %User{} = user) do
    AccountsMock
    |> expect(:get_user!, fn _ -> user end)

    conn
    |> init_test_session(%{current_user_id: user.id})
  end

  def sign_in_as_admin(conn, %User{} = user \\ %User{id: 1}) do
    AccountsMock
    |> expect(:is_admin?, fn _ -> true end)

    sign_in(conn, user)
  end

  def sign_in_as_non_admin(conn, %User{} = user \\ %User{id: 1}) do
    AccountsMock
    |> expect(:is_admin?, fn _ -> false end)

    sign_in(conn, user)
  end
end
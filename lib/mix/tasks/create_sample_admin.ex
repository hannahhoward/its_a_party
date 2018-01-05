defmodule Mix.Tasks.CreateSampleAdmin do
  use Mix.Task
  @accounts Application.get_env(:its_a_party, :accounts)

  def run(_) do
    Mix.Task.run("app.start", [])

    @accounts.create_user(%{
      first_name: "Admin",
      last_name: "User",
      credential: %{
        email: "admin@its-a-party.net",
        password: "Password12",
        password_confirmation: "Password12"
      }
    })
  end
end
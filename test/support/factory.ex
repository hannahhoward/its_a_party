# defmodule ItsAParty.Factory do
#   # with Ecto
#   use ExMachina.Ecto, repo: ItsAParty.Repo

#   # without Ecto
#   use ExMachina

#   def user_factory do
#     %ItsAParty.Accounts.User{
#       first_name: "Jane",
#       last_name: "Smith",
#       roles: [],
#       credential: build(:credential),
#     }
#   end

#   def credential_factory do
#     %ItsAParty.Accounts.Credential{
#       email: sequence(:email, &"email-#{&1}@example.com"),
#       password: "password12",
#       password_confirmation: "password12"
#     }
#   end

# end
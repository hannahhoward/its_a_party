# ItsAParty

A server for creating and managing contacts, and setting up event invites

### Patterns

Also a playground for me to experiment with Phoenix 1.3 and various test patterns

Some things I'm trying:

* Using Dialyzer wherever possible (w/ explicit typespecs)
* Using Behaviors
* Specifically using behaviors as a testing strategy -- to implement patterns describe by Jose Valim in ["Mocks and explicit contracts"](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/)
* Even more specifically applying this pattern to mock domain contexts in tests of web code

### Status

What Exists:

* Accounts system which allows log in / log out, as well as protected routes (that can simply require being loggen in, or that can require an admin role)
* Account management via an admin interface
* Contacts system which allows managing contacts, and more importantly, protects from users managing other users contacts

To Do:

* Events/Invitations system
* Intend to add GraphQL API for a frontend site where attendees could view event details
* Any kind of navigation (you just have to know routes for now)

### Setup

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Install Node.js dependencies with `cd assets && npm install`
* Create an initial sample admin user with 'mix create_sample_admin' (email: "admin@its-a-party.net", password: "Password12")
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

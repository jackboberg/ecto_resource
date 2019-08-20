# EctoResource

Eliminate boilerplate involved in defining basic CRUD functions in a Phoenix context or Elixir module.

Turn this:

```elixir
defmodule MyApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end

```

Into this:

```elixir
defmodule MyApp.Accounts do
  use EctoResource

  alias MyApp.Repo
  alias MyApp.Accounts.User

  using_repo(Repo) do
    resource(User)
  end
end

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_resource` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_resource, "~> 0.1.0"}
  ]
end
```

## Basic Usage

All examples are using a "context" module `Accounts` and a schema of `User`. This can be substituted for your Phoenix context, or any other module and schema.

```elixir
  defmodule Accounts do
    use EctoResource

    using_repo(Repo) do
      resource(User)
    end
  end
```

This will generate the functions:

```elixir
def create_user(attributes) do
  EctoResource.create(Repo, User, attributes)
end

def create_user!(attributes) do
  EctoResource.create!(Repo, User, attributes)
end

def all_users(options) do
  EctoResource.all(Repo, User, options)
end

def get_user(id, options) do
  EctoResource.get(Repo, User, id, options)
end

def get_user!(id, options) do
  EctoResource.get!(Repo, User, id, options)
end

def change_user(struct_or_changeset) do
  EctoResource.change(User, struct_or_changeset)
end

def update_user(%User{id: 1}, changeset) do
  EctoResource.update(Repo, User, struct, changeset)
end

def update_user!(%User{id: 1}, changeset) do
  EctoResource.update!(Repo, User, struct, changeset)
end

def delete_user(struct_or_changeset) do
  EctoResource.delete(Repo, struct_or_changeset)
end

def delete_user!(struct_or_changeset) do
  EctoResource.delete!(Repo, struct_or_changeset)
end
```

There are also introspection functions to understand what is generated by the macro

```elixir
Accounts.__resource__(:resources) == [
  {Repo, User,
    [
      "all_users/1",
      "change_user/1",
      "create_user/1",
      "create_user!/1",
      "delete_user/1",
      "delete_user!/1",
      "get_user/2",
      "get_user!/2",
      "update_user/2",
      "update_user!/2"
    ]}
]
```

## Advanced usage

More granular control is available through options

## :read

```elixir
defmodule Accounts do
  use EctoResource

  using_repo(Repo) do
    resource(User, :read)
  end
end
```

This will generate the functions:

```elixir
def all_users(options) do
  EctoResource.all(Repo, User, options)
end

def get_user(id, options) do
  EctoResource.get(Repo, User, id, options)
end

def get_user!(id, options) do
  EctoResource.get!(Repo, User, id, options)
end
```

There are also introspection functions to understand what is generated by the macro

```elixir
Accounts.__resource__(:resources) == [
  {Repo, User,
    [
      "all_users/1",
      "get_user/2",
      "get_user!/2"
    ]}
]
```

## :write

```elixir
defmodule Accounts do
  use EctoResource

  using_repo(Repo) do
    resource(User, :write)
  end
end
```

This will generate the functions:

```elixir
def create_user(attributes) do
  EctoResource.create(Repo, User, attributes)
end

def create_user!(attributes) do
  EctoResource.create!(Repo, User, attributes)
end

def change_user(struct_or_changeset) do
  EctoResource.change(User, struct_or_changeset)
end

def update_user(%User{id: 1}, changeset) do
  EctoResource.update(Repo, User, struct, changeset)
end

def update_user!(%User{id: 1}, changeset) do
  EctoResource.update!(Repo, User, struct, changeset)
end
```

There are also introspection functions to understand what is generated by the macro

```elixir
Accounts.__resource__(:resources) == [
  {Repo, User,
    [
      "change_user/1",
      "create_user/1",
      "create_user!/1",
      "update_user/2",
      "update_user!/2"
    ]}
]
```

## :delete

```elixir
defmodule Accounts do
  use EctoResource

  using_repo(Repo) do
    resource(User, :delete)
  end
end
```

This will generate the functions:

```elixir
def delete_user(struct_or_changeset) do
  EctoResource.delete(Repo, struct_or_changeset)
end

def delete_user!(struct_or_changeset) do
  EctoResource.delete!(Repo, struct_or_changeset)
end
```

There are also introspection functions to understand what is generated by the macro

```elixir
Accounts.__resource__(:resources) == [
  {Repo, User,
    [
      "delete_user/1",
      "delete_user!/1"
    ]}
]
```

## :only

```elixir
defmodule Accounts do
  use EctoResource

  using_repo(Repo) do
    resource(User, only: [:change])
  end
```

This will generate the functions:

```elixir
def change_user(struct_or_changeset) do
  EctoResource.change(User, struct_or_changeset)
end
```

There are also introspection functions to understand what is generated by the macro

```elixir
Accounts.__resource__(:resources) == [
  {Repo, User,
    [
      "change_user/1"
    ]}
]
```

## :except

```elixir
defmodule Accounts do
  use EctoResource

  using_repo(Repo) do
    resource(User, except: [:change])
  end
```

This will generate the functions:

```elixir
def create_user(attributes) do
  EctoResource.create(Repo, User, attributes)
end

def create_user!(attributes) do
  EctoResource.create!(Repo, User, attributes)
end

def all_users(options) do
  EctoResource.all(Repo, User, options)
end

def get_user(id, options) do
  EctoResource.get(Repo, User, id, options)
end

def get_user!(id, options) do
  EctoResource.get!(Repo, User, id, options)
end

def update_user(%User{id: 1}, changeset) do
  EctoResource.update(Repo, User, struct, changeset)
end

def update_user!(%User{id: 1}, changeset) do
  EctoResource.update!(Repo, User, struct, changeset)
end

def delete_user(struct_or_changeset) do
  EctoResource.delete(Repo, struct_or_changeset)
end

def delete_user!(struct_or_changeset) do
  EctoResource.delete!(Repo, struct_or_changeset)
end
```

There are also introspection functions to understand what is generated by the macro

```elixir
Accounts.__resource__(:resources) == [
  {Repo, User,
    [
      "all_users/1",
      "create_user/1",
      "create_user!/1",
      "delete_user/1",
      "delete_user!/1",
      "get_user/2",
      "get_user!/2",
      "update_user/2",
      "update_user!/2"
    ]}
]
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecto_resource](https://hexdocs.pm/ecto_resource).


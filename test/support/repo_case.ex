defmodule EctoResource.RepoCase do
  use ExUnit.CaseTemplate

  alias Ecto.Integration.TestRepo

  using do
    quote do
      alias Ecto.Integration.TestRepo, as: Repo
      # alias EctoResource.TestRepo, as: Repo
      import Ecto
      import Ecto.Query
      import EctoResource.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TestRepo, {:shared, self()})
    end

    :ok
  end
end

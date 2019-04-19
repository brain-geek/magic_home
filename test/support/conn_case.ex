defmodule MagicHomeWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias MagicHomeWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint MagicHomeWeb.Endpoint

      import MagicHome.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MagicHome.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(MagicHome.Repo, {:shared, self()})
    end

    MagicHome.TestTools.disable_feature_flags()

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

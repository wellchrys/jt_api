defmodule JustWeb.HeartCheck do
  @moduledoc false

  use HeartCheck

  alias Just.Repo

  add :postgresql do
    case ping_repo(Repo) do
      {:ok, _} -> :ok
      {:error, exception} -> {:error, Exception.message(exception)}
    end
  end

  defp ping_repo(repo) do
    repo.query("SELECT 1")
  rescue
    exception -> {:error, exception}
  end
end

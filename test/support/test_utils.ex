defmodule Just.TestUtils do
  @moduledoc false

  import Ecto.Query

  alias Just.Repo

  def force_update_by_id(queryable, id, params) do
    queryable
    |> where([o], o.id == ^id)
    |> update(set: ^params)
    |> Repo.update_all([])
  end
end

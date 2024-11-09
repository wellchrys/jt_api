defmodule JustWeb.GraphQL.Schema do
  @moduledoc false

  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(JustWeb.GraphQL.Types.RootQuery)
  import_types(JustWeb.GraphQL.Types.RootMutation)

  query do
    import_fields(:root_query)
  end

  mutation do
    import_fields(:root_mutation)
  end

  def middleware(middleware, _field, _object) do
    middleware ++ [JustWeb.GraphQL.Middlewares.HandleErrors]
  end
end

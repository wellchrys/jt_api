defmodule JustWeb.GraphQL.Paginator do
  @moduledoc false

  @max_page_size 10_000
  @maximum_limit 10_000
  @default_page_size 10
  @default_maximum_limit 100

  @type args :: %{
          optional(:page_size) => nil | pos_integer(),
          optional(:maximum_limit) => nil | pos_integer(),
          optional(:after) => nil | String.t(),
          optional(:before) => nil | String.t(),
          optional(:filters) => map()
        }

  @type pagination_args :: %{
          required(:page_size) => pos_integer(),
          required(:maximum_limit) => pos_integer(),
          required(:after_cursor) => nil | String.t(),
          required(:before_cursor) => nil | String.t(),
          required(:filters) => map()
        }

  @spec transform_args!(args()) :: pagination_args()
  def transform_args!(args) do
    args
    |> Map.put(:page_size, page_size(args))
    |> Map.put(:maximum_limit, maximum_limit(args))
    |> Map.put(:after_cursor, args[:after])
    |> Map.put(:before_cursor, args[:before])
    |> Map.put(:filters, filters(args))
  end

  defp filters(args) do
    if args[:filters], do: args[:filters], else: %{}
  end

  defp page_size(args) do
    if args[:page_size],
      do:
        args[:page_size]
        |> abs()
        |> min(@max_page_size),
      else: @default_page_size
  end

  defp maximum_limit(args) do
    if args[:maximum_limit],
      do:
        args[:maximum_limit]
        |> abs()
        |> min(@maximum_limit),
      else: @default_maximum_limit
  end
end

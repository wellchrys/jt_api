defmodule Just.Tickets do
  @moduledoc """
    Provides a set of functions for managing tickets context.
  """

  import Ecto.Query, only: [from: 2, order_by: 3, where: 3]
  import Just.Filters

  alias Just.Repo
  alias Just.Tickets.Ticket

  @cursor_fields [{:id, :desc}]

  @type list_attrs :: %{
          required(:before_cursor) => nil | String.t(),
          required(:after_cursor) => nil | String.t(),
          required(:page_size) => pos_integer(),
          required(:maximum_limit) => pos_integer(),
          required(:filters) => map()
        }

  @type list_result ::
          {:ok,
           %{
             required(:entries) => [Ticket.t()],
             required(:before_cursor) => nil | String.t(),
             required(:after_cursor) => nil | String.t()
           }}

  @doc """
    Get ticket by its identifier.

  ## Examples

      iex> Just.Tickets.find(1)
      {:ok, %Ticket{}}

      iex> Just.Tickets.find(2)
      {:error, :ticket_not_found}

  """
  @spec find(pos_integer()) ::
          {:ok, Ticket.t()} | {:error, :ticket_not_found}
  def find(ticket_id) do
    case ticket()
         |> by_ticket_id(ticket_id)
         |> Repo.one() do
      nil -> {:error, :ticket_not_found}
      ticket -> {:ok, ticket}
    end
  end

  @doc """
    List tickets.

  ## Examples

      iex> Just.Tickets.list()
      [%Ticket{}]

      iex> Just.Tickets.list()
      []

  """
  @spec list(list_attrs()) :: list_result()
  def list(%{
        before_cursor: before_cursor,
        after_cursor: after_cursor,
        page_size: page_size,
        maximum_limit: maximum_limit,
        filters: filters
      }) do
    filter_ticket_name = handle_filter_options([:ticket_name], filters)

    %Paginator.Page{
      entries: entries,
      metadata: %Paginator.Page.Metadata{
        after: after_cursor,
        before: before_cursor
      }
    } =
      ticket()
      |> apply_filters(filter_ticket_name)
      |> order_by([ticket: b], desc: b.id)
      |> Repo.paginate(
        before: before_cursor,
        after: after_cursor,
        cursor_fields: @cursor_fields,
        limit: page_size,
        maximum_limit: maximum_limit
      )

    {:ok,
     %{
       entries: entries,
       after_cursor: after_cursor,
       before_cursor: before_cursor
     }}
  end

  defp ticket do
    from(ticket in Ticket, as: :ticket)
  end

  defp by_ticket_id(queryable, ticket_id) do
    where(queryable, [ticket: b], b.id == ^ticket_id)
  end
end

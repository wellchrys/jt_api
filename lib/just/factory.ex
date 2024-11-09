defmodule Just.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Just.Repo

  alias Just.Tickets.Ticket

  def ticket_factory do
    %Ticket{
      ticket_name: sequence(:ticket_name, &"Ticket Name #{&1}"),
      ticket_value: 100 |> Faker.random_between(900) |> Decimal.new(),
      ticket_discount_value: 100 |> Faker.random_between(900) |> Decimal.new(),
      ticket_location: Faker.Address.city(),
      ticket_grade: Faker.random_between(1, 10) |> Decimal.new(),
      ticket_reviews: Faker.random_between(1, 10),
      ticket_img: Faker.Internet.image_url()
    }
  end
end

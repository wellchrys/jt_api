defmodule Just.SeederTest do
  use Just.DataCase, async: true

  alias Just.Seeder
  alias Just.Tickets.Ticket

  describe "create!" do
    test "properly populate database" do
      assert Just.Repo.all(Ticket) == []

      assert :ok == Seeder.create!()

      refute Just.Repo.all(Ticket) == []
    end
  end
end

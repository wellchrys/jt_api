defmodule Just.Repo.Migrations.CreateTicketsTable do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add(:ticket_name, :string, null: false)
      add(:ticket_value, :decimal, null: false)
      add(:ticket_discount_value, :decimal, null: false)
      add(:ticket_location, :string, null: false)
      add(:ticket_grade, :decimal, null: false)
      add(:ticket_reviews, :integer, null: false)
      add(:ticket_img, :string, null: false, size: 500)

      timestamps()
    end

    create(
      unique_index(
        :tickets,
        [
          :ticket_name,
        ],
        name: :unique_ticket_by_ticket_name
      )
    )
  end
end

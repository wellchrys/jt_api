defmodule Just.ReleaseTasks do
  @moduledoc false

  @app :just

  alias Ecto.Migrator
  alias Just.{Repo, Seeder}

  def seed do
    {:ok, _} = Application.ensure_all_started(@app)

    Seeder.create!()
  end

  def migrate do
    :ok = Application.ensure_loaded(@app)
    {:ok, _, _} = Migrator.with_repo(Repo, &Migrator.run(&1, :up, all: true))
  end

  def rollback do
    :ok = Application.ensure_loaded(@app)
    {:ok, _, _} = Migrator.with_repo(Repo, &Migrator.run(&1, :down, step: 1))
  end
end

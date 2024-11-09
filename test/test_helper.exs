ExUnit.start()
Code.put_compiler_option(:warnings_as_errors, true)
Ecto.Adapters.SQL.Sandbox.mode(Just.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)

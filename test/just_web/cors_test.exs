defmodule JustWeb.CORSTest do
  use ExUnit.Case, async: true

  alias JustWeb.CORS

  describe "check_origin/1" do
    test "return false when single origin is provided and not allowed" do
      refute CORS.check_origin("localhost:3000")
    end

    for origin <- [
          "staging.mydomain.com.br",
          "prod.mydomain.com.br"
        ] do
      test "return true when origin is #{origin}" do
        assert CORS.check_origin(unquote(origin))
      end
    end
  end
end

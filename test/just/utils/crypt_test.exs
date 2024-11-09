defmodule Just.Utils.CryptTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Just.Utils.Crypt

  describe "encrypt/1" do
    test "should successfully encrypt a passed plain text" do
      plain_text = "Te$t1234"

      encrypted_text = Crypt.encrypt!(plain_text)

      refute plain_text == encrypted_text
    end
  end

  describe "decrypt/1" do
    test "should successfully decrypt a passed plain text" do
      plain_text = "Te$t1234"

      encrypted_text = Crypt.encrypt!(plain_text)
      decrypted_text = Crypt.decrypt!(encrypted_text)

      assert plain_text == decrypted_text
    end
  end
end

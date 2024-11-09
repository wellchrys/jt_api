defmodule Just.Utils.Crypt do
  @moduledoc false

  @block_size 16
  @secret_key "C0BB2391797AF7B5"

  def encrypt!(plain_text) do
    iv = :crypto.strong_rand_bytes(16)
    plain_text = pad(plain_text, @block_size)
    encrypted_text = :crypto.crypto_one_time(:aes_128_cbc, @secret_key, iv, plain_text, true)
    encrypted_text = iv <> encrypted_text
    :base64.encode(encrypted_text)
  end

  def decrypt!(cipher_text) do
    cipher_text = :base64.decode(cipher_text)
    <<iv::binary-16, cipher_text::binary>> = cipher_text
    decrypted_text = :crypto.crypto_one_time(:aes_128_cbc, @secret_key, iv, cipher_text, false)
    unpad(decrypted_text)
  end

  defp unpad(data) do
    to_remove = :binary.last(data)
    :binary.part(data, 0, byte_size(data) - to_remove)
  end

  defp pad(data, block_size) do
    to_add = block_size - rem(byte_size(data), block_size)
    data <> :binary.copy(<<to_add>>, to_add)
  end
end

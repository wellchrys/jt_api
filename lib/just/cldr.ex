defmodule Just.Cldr do
  @moduledoc false

  use Cldr,
    locales: ["en"],
    default_locale: "en",
    providers: [Cldr.Number, Money]
end

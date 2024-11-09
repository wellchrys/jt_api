[
  inputs: [
    "mix,.formatter.exs",
    "lib/**/*.{ex,exs}",
    "test/**/*.{ex,exs}",
    "bin/*.{ex,exs}",
    "config/*.{ex,exs}",
    "priv/repo/*.{ex,exs}",
    "*.{ex,exs}"
  ],
  line_length: 100,
  locals_without_parens: [
    assert_eventual: 1
  ]
]

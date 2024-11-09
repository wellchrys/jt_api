defmodule Just.Seeder do
  @moduledoc false

  import Just.Factory

  @source_images [
    "https://s3-alpha-sig.figma.com/img/6100/5c68/da34365b4777e61b21faaca0291e3746?Expires=1731888000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=gOcu0YLUx3S60VZVIHwuG1fgJpj8kWNdu3G1ebSvSk~We9H9EMQDOPlLc8UvG-4Ddk5PFkZaUg64MX-QT77q4Y4JHTUE80iFlgnxCMuAe6DAeD0WtHw~DqEHCecM5u0zt6M~pH8TOVBtBFs3UeCPC9SjHP7HIujNT4pg8xqhWAQpMTeDqWcgjSStQZNTLQ~B9qZoY7t6NLI9qPhf5vxaq7HNO8IeL8v6Ww~MZvZkDFfaIklrqcQR2s8ELXB-c3VMRgcnocF81r8WiuU2278XUoaRpVLMYMCG2-YLtceL85Ap29S5w~XFKR3zAHpWy3xXRCVvPHhCGc1Y~NtnFYvgyQ__",
    "https://s3-alpha-sig.figma.com/img/92d0/94ec/0cd3e90a86e372c5d7542d2d23c38a74?Expires=1731888000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=XQxdoPauvGUvqyD2yFcitjqhzY-hbvQhpzx~ZXAaKOuii~Lag6t5G64VW~8hJk9zhD-xDnsdsrQpp-fKrE2K3WOwRDfmo8vOUvWa9tNGdpFN9zdNJuDTwvoibRJ5mNIDBEXEdiXle8PbSVrPVjoHXYkIP0TgCzF24wzpE~Muzmi7fT~BnEH4Z9lyK1m7UXQ9YSVLkZ31ZIwqXOTXLZznVky4AvJ4OEmddIjHpBm1bUHbLYNZIF3ZPwCQObyQ80qcdeBSsWXTOqe-wC2yKHUP1887mNA9iXekgBIljLJQyxNKxLLD4ZM6PWSiRJNjCTAk3wwmxK5SNfd-qiPnz1KbpA__",
    "https://s3-alpha-sig.figma.com/img/7cbf/f5d1/ed1bda44f1fd8fde7823420208eef5bd?Expires=1731888000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=FpB~YDwI9065Hh0Tk2eSsScRmYWPG9opfWo4jibxSwC3mTbl58eD7RhAg6UOv~6kTWj~xiXwusL0Nvi2bxklcdNlNNLeSzxFXaqNznJYjJUDTmsxaDbsBj0x69Rfxuw5N0nbGcU~aOO4Aye-ZSKSPsDNFO9cZMaNymbBRSMw8YkrODqc~IwqymH5XMmJC8bZCMFlCZPDldAq4dC8S7dr1gWl22PIoGFeRuWM3edW4v6IWMuaV0ejbOCCzAn1-IW0dY1hOEF2kUzypD2YPIpWrjDfzEb3PovGGy-bK9MSzrT1DGGfyD3GTPJt8krdeKsoFxitwlK464k4hNMe5UwTBw__",
    "https://s3-alpha-sig.figma.com/img/37fd/8d9d/251f14e52b3a890667c9da706a663661?Expires=1731888000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=R75w8MtQRj1SX348Lplg-d2p-2IHceESJMxUItnnh77rFYXdGSKeFn9FlhUX7DQiZ0OeWyQIR~giYScL3sIbh5Pspkugxo-i8PB7GlJWl0xpeGPkGXhbqhkXAb2NGTFAzhP5eH6Y6-neCIC4UEirb3GsWOjNsNrfDT7UQy36KhnL-s22z97prya8ZOcLzyFIng~S9IesSAryLFei9GXGqZ-C22hcaLPZJziQ15jweB7JDjbW6IUC~Usi8OMAfmzsy3hR9aBi303uyILLdyDAPfA7~S8EE1B2Fyqc64Xu4~te07z9pOiZz1zgALE7~eFg2iXzNTYyLaXYnASKYqglng__"
  ]

  def create!() do
    1..20
    |> Enum.to_list()
    |> Enum.each(
      &insert(:ticket,
        ticket_name: "Ticket Name #{&1}",
        ticket_value: 100 |> Faker.random_between(200) |> Decimal.new(),
        ticket_discount_value: 60 |> Faker.random_between(100) |> Decimal.new(),
        ticket_location: Faker.Address.city(),
        ticket_grade: 1 |> Faker.random_between(10) |> Decimal.new(),
        ticket_reviews: Faker.random_between(1, 100),
        ticket_img: @source_images |> Enum.at(Faker.random_between(0, 3))
      )
    )

    :ok
  end
end

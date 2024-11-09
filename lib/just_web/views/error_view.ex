defmodule JustWeb.ErrorView do
  use JustWeb, :view

  def render("401.json", _assigns) do
    %{
      errors: [
        %{
          title: "Unauthorized",
          detail: "You are not authorized to access this page"
        }
      ]
    }
  end
end

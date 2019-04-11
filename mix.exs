defmodule AliceGoodMorning.Mixfile do
  use Mix.Project

  def project do
    [
      app: :alice_good_morning,
      version: "1.0.5",
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:alice, "~> 0.3"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    This handler will allow Alice to say good morning to people in different languages.

    It does so only once each morning.
    """
  end

  defp package do
    [
      files: ["lib", "config", "mix.exs", "README*"],
      maintainers: ["Tyler Clemens"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/tielur/alice_good_morning/",
        "Docs" => "https://github.com/tielur/alice_good_morning/"
      }
    ]
  end
end

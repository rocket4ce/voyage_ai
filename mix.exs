defmodule VoyageAi.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/rocket4ce/voyage_ai"

  def project do
    [
      app: :voyage_ai,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {VoyageAi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Cliente Elixir para VoyageAI API que permite generar embeddings y reordenar documentos.
    """
  end

  defp package do
    [
      maintainers: ["rocket4ce"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @github_url,
      extras: ["README.md"]
    ]
  end
end

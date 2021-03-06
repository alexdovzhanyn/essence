defmodule Essence.Mixfile do
  use Mix.Project

  def project do
    [
      app: :essence,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :cowboy, :plug, :ecto],
      mod: {Essence.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.3"},
      {:plug, "~> 1.0"},
      {:ecto, "~> 2.1"},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end

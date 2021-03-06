defmodule GenstageEscript.MixProject do
  use Mix.Project

  def project do
    [
      app: :genstage_escript,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Commandline.CLI],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 0.7"},
      {:optimus, "~> 0.1.0"}
    ]
  end
end

defmodule Mix.Tasks.ExportTestEnvVariables do
  use Mix.Task

  def run(_args) do
    # source the env file
    System.cmd("source", [".env"])
    # or run cmd command to set ENV
    System.cmd("export", ["hannah=hannahslack"])
    System.cmd("export hannah=hannahslack", [])
  end
end

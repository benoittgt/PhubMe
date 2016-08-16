defmodule PhubMe.Web do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass:  ["text/*"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    {:ok, _ } = Plug.Adapters.Cowboy.http PhubMe.Web, []
  end

  post "/" do
    IO.inspect conn.req_headers
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "ok")
    |> halt
  end

  match _ do
    conn
    |> send_resp(404, "")
    |> halt
  end
end

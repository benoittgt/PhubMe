defmodule PhubMe.Web do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json],
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
    parsed_comment = PhubMe.CommentParser.process_comment(conn.body_params)
    IO.inspect parsed_comment
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "ok")
    |> halt
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "")
    |> halt
  end
end

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
    # IO.inspect conn.req_headers
    # How to test that it has been properly sent to ...
    # IO.inspect conn.body_params
    PhubMe.CommentParser.process_comment(conn.body_params)
    |> PhubMe.NicknamesMatcher.match_nicknames
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

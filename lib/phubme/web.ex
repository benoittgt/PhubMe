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
    {:ok, _ } = Plug.Adapters.Cowboy.http PhubMe.Web, [], port: port(System.get_env("PORT"))
  end

  def port(nil), do: 8080

  def port(value) do
    String.to_integer(value)
  end

  post "/phubme" do
    PhubMe.CommentParser.process_comment(conn.body_params)
    |> PhubMe.NicknamesMatcher.match_nicknames
    |> PhubMe.Slack.send_private_message
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

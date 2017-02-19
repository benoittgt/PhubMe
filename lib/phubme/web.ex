defmodule PhubMe.Web do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    adapeur_port = String.to_integer(System.get_env("PORT") || "8080")
    {:ok, _ } = Plug.Adapters.Cowboy.http(PhubMe.Web, [], port: adapeur_port)
  end

  post "/phubme" do
      if valid_github_payload?(conn.body_params, conn.req_headers) do
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, "ok")
        |> halt
      else
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, "")
        |> halt
    end
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "")
    |> halt
  end

  def valid_github_payload?(%{"issue" => _issue} = body_params, [{"x-github-event", "issue_comment"}, __content_type]) do
    PhubMe.CommentParser.process_comment(body_params)
    |> PhubMe.NicknamesMatcher.match_nicknames
    |> PhubMe.Slack.send_private_message
  end

  def valid_github_payload?(%{"hook" => _hook} = _body_params, [{"x-github-event", "ping"}, _content_type]) do
    true
  end

  def valid_github_payload?(_body_params, _req_headers) do
    false
  end
end

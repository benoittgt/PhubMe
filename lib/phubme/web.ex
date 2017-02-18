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
    {:ok, _ } = Plug.Adapters.Cowboy.http(PhubMe.Web,
                                          [],
                                          port: port(System.get_env("PORT")))
  end

  def port(nil), do: 8080

  def port(value) do
    String.to_integer(value)
  end

  post "/phubme" do
    cond do
      valid_github_payload?(conn.body_params, conn.req_headers) ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, "ok")
        |> halt
      true ->
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

  def valid_github_payload?(body_params, req_headers) do
    cond do
      Map.has_key?(body_params, "issue") &&
        req_headers == [{"x-github-event", "issue_comment"}, {"content-type", "application/json"}] ->
        PhubMe.CommentParser.process_comment(body_params)
        |> PhubMe.NicknamesMatcher.match_nicknames
        |> PhubMe.Slack.send_private_message
      Map.has_key?(body_params, "hook") &&
        req_headers == [{"x-github-event", "ping"}, {"content-type", "application/json"}] -> true
      true -> false
    end
  end
end

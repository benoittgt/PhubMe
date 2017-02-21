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
    port = String.to_integer(System.get_env("PORT") || "8080")
    {:ok, _ } = Plug.Adapters.Cowboy.http(PhubMe.Web, [], port: port)
  end

  post "/phubme" do
    if valid_github_payload?(conn.body_params, get_req_header(conn, "x-github-event")) do
      handle_github_payload(conn.body_params)
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

  defp valid_github_payload?(%{"issue" => _issue}, ["issue_comment"]), do: true
  defp valid_github_payload?(%{"hook" => _hook}, ["ping"]), do: true
  defp valid_github_payload?(_body_params, _req_header), do: false

  defp handle_github_payload(%{"issue" => _issue} = body_params) do
    PhubMe.CommentParser.process_comment(body_params)
    |> PhubMe.NicknamesMatcher.match_nicknames
    |> PhubMe.Slack.send_private_message
  end

  defp handle_github_payload(_body_params) do
    :not_an_issue_comment
  end
end

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
    IO.inspect conn.body_params
    IO.inspect conn.req_headers
    %{"issue" => _issue} = conn.body_params
    [{"x-github-event", "issue_comment"}, _content_type] = conn.req_headers
    if valid_github_payload?(conn.body_params, conn.req_headers) do
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

  defp valid_github_payload?(%{"issue" => _issue}, [{"x-github-event", "issue_comment"}, _content_type]), do: true
  defp valid_github_payload?(%{"hook" => _hook}, [{"x-github-event", "ping"}, _content_type]), do: true
  defp valid_github_payload?(_body_params, _req_headers), do: false

  defp handle_github_payload(%{"issue" => _issue} = body_params) do
    PhubMe.CommentParser.process_comment(body_params)
    |> PhubMe.NicknamesMatcher.match_nicknames
    |> PhubMe.Slack.send_private_message
  end

  defp handle_github_payload(_body_params) do
    :not_an_issue_comment
  end
end

defmodule PhubMe.WebTest do
  use ExUnit.Case, async: false
  use Plug.Test

  @opts PhubMe.Web.init([])
  @github_issue_comment_request_json File.read!("test/fixtures/github_issue_comment_request.json")

  @headers_expected [{"x-github-event", "issue_comment"},
   {"content-type", "application/json"}]

  test "returns ok when posting / with params" do
    conn = conn(:post, "/", @github_issue_comment_request_json)
            |> put_req_header("x-github-event", "issue_comment")
            |> put_req_header("content-type", "application/json")
    conn = PhubMe.Web.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.req_headers == @headers_expected
    assert conn.params == Poison.decode! @github_issue_comment_request_json
    assert conn.resp_body == "ok"
  end

  test "404 when wrong route" do
    conn = conn(:post, "/yep")
    conn = PhubMe.Web.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end
end

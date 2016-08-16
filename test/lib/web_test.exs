defmodule PhubMe.WebTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts PhubMe.Web.init([])
  @github_issue_comment_request_json File.read!("test/fixtures/github_issue_comment_request.json")


  test "returns ok when posting /" do
    conn = %{req_headers: [{"x-github-event", "issue_comment"}],
     body_params: Poison.decode! @github_issue_comment_request_json}

    {_, json} = PhubMe.Web.call(conn, @opts)

    IO.inspect json

    # params = "{\"auth_token\":1}"
    # conn = conn(:post, "/", params)
    # conn = PhubMe.Web.call(conn, @opts)

    # assert conn.state == :sent
    # assert conn.status == 200
    # assert conn.params == %{auth_token: 1}
    # assert conn.resp_body == "ok"
  end

  test "404 when wrong route" do
    conn = conn(:post, "/yep")
    conn = PhubMe.Web.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end
end

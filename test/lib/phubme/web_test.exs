defmodule PhubMe.WebTest do
  use ExUnit.Case, async: false
  use Plug.Test
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @opts PhubMe.Web.init([])
  @github_issue_comment_request_json File.read!("test/fixtures/github_issue_comment_request.json")
  @github_firt_call_after_webhook_creation_json File.read!("test/fixtures/github_firt_call_after_webhook_creation.json")

  @issue_headers_expected [{"host", "herokuapp.com"}, {"x-github-event", "issue_comment"}, {"content-type", "application/json"}]
  @ping_headers_expected [{"host", "herokuapp.com"}, {"x-github-event", "ping"}, {"content-type", "application/json"}]

  test "returns ok when posting on /phubme with params" do
    use_cassette "slack channel found" do
      conn = conn(:post, "/phubme", @github_issue_comment_request_json)
             |> put_req_header("host", "herokuapp.com")
             |> put_req_header("x-github-event", "issue_comment")
             |> put_req_header("content-type", "application/json")
      conn = PhubMe.Web.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.req_headers == @issue_headers_expected
      assert conn.params == Poison.decode! @github_issue_comment_request_json
      assert conn.resp_body == "ok"
    end
  end

  test "returns 200 when posting on /phubme with first github call" do
      conn = conn(:post, "/phubme", @github_firt_call_after_webhook_creation_json)
             |> put_req_header("host", "herokuapp.com")
             |> put_req_header("x-github-event", "ping")
             |> put_req_header("content-type", "application/json")
      conn = PhubMe.Web.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.req_headers == @ping_headers_expected
      assert conn.params == Poison.decode! @github_firt_call_after_webhook_creation_json
      assert conn.resp_body == "ok"
  end

  test "returns 404 when posting on /phubme without correct payload" do
    conn = conn(:post, "/phubme", %{"none" => "none"})
           |> put_req_header("host", "herokuapp.com")
           |> put_req_header("x-thub-event", "issue_comment")
           |> put_req_header("content-type", "application/json")
    conn = PhubMe.Web.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end

  test "404 when wrong route" do
    conn = conn(:post, "/yep")
    conn = PhubMe.Web.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end
end

defmodule PhubMe.WebTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts PhubMe.Web.init([])

  test "returns ok when getting /" do
    conn = conn(:post, "/")
    conn = PhubMe.Web.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
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

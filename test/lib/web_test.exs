defmodule MyPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts PhubMe.Web.init([])

  test "returns ok when getting /" do
    # Create a test connection
    conn = conn(:get, "/")

    # Invoke the plug
    conn = PhubMe.Web.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end

  test "404 when wrong route" do
    conn = conn(:get, "/yep")
    conn = PhubMe.Web.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end
end

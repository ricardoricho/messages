defmodule Messages.MessageTest do
  use ExUnit.Case
  alias Messages.Message

  test "short_body" do
    message = %Message{body: "short body"}
    assert "short..." = Message.short_body(message, 5)
    assert "short body..." = Message.short_body(message, 20)
  end
end

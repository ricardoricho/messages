defmodule Messages.SlackMessageTest do
  use ExUnit.Case
  alias Messages.SlackMessage

  test "changeset" do
    message = %SlackMessage{slack_timestamp: "ts", slack_channel: "channel"}
    slack_message = SlackMessage.changeset(message, %{slack_message: "message"})
    assert true = slack_message.valid?
  end
end

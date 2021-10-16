defmodule Messages.MessengerTest do
  use ExUnit.Case
  import Mox
  alias Messages.Messenger

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Messages.Repo, :auto)
  end

  describe "delete_message when message hasn't slack_message" do
    test "it returns ok with self as identity" do
      message = Messages.Message.create(%{subject: "subject", body: "body"})
      assert {:ok, _} = Messenger.delete_from_slack(message)
    end
  end

  test "when message has slack_message" do
    {:ok, message} = Messages.Message.create(%{subject: "subject", body: "body"})

    Messages.SlackMessage.create(%{
      slack_timestamp: "timestamp",
      slack_message: "message encode from slack",
      slack_channel: "channel code from slack",
      message_id: message.id
    })

    slack_confirm_delete = %{ok: true}
    expect(Messages.SlackMock, :delete, fn _ -> slack_confirm_delete end)
    assert deleted = Messenger.delete_from_slack({:ok, message})
    assert deleted.ok == true
  end
end

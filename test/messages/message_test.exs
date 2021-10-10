defmodule Messages.MessageTest do
  use ExUnit.Case
  alias Messages.Message

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Messages.Repo, :auto)
  end

  test "not_deleted" do
    params = %{subject: "subject", body: "body"}
    {:ok, message} = Message.create(params)
    {:ok, deleted_message} = Message.create(Map.merge(params, %{deleted_at: DateTime.utc_now}))
    messages = Messages.Message.not_deleted()
    assert Enum.member?(messages, message)
    refute Enum.member?(messages, deleted_message)
  end

  test "short_body" do
    message = %Message{body: "short body"}
    assert "short..." = Message.short_body(message, 5)
    assert "short body..." = Message.short_body(message, 20)
  end

  test "soft_delete" do
    {:ok, message } = Message.create(%{subject: "subject", body: "body"})
    {:ok, deleted_message } = Message.soft_delete(message)
    assert deleted_message.deleted_at
  end
end

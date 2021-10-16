defmodule MessagesWeb.MessageControllerTest do
  import Mox
  use MessagesWeb.ConnCase

  test "GET /messages", %{conn: conn} do
    conn = get(conn, Routes.message_path(conn, :index))
    assert html_response(conn, 200) =~ "Messages"
  end

  test "GET /messages (with data)", %{conn: conn} do
    {:ok, message1} =
      Messages.Message.create(%{subject: "Message 1 subject", body: "Message 1 body"})

    {:ok, message2} =
      Messages.Message.create(%{subject: "Message 2 subject", body: "Message 2 body"})

    conn = get(conn, Routes.message_path(conn, :index))
    response = html_response(conn, 200)
    assert response =~ message1.subject
    assert response =~ message2.subject
  end

  test "GET /new", %{conn: conn} do
    conn = get(conn, Routes.message_path(conn, :new))
    response = html_response(conn, 200)
    assert response =~ "Subject"
    assert response =~ "Body"
  end

  test "POST /messages", %{conn: conn} do
    expect(Messages.SlackMock, :push, fn a -> {:ok, a} end)
    data = %{subject: "Subject", body: "Message body"}
    conn = post(conn, Routes.message_path(conn, :create), message: data)
    response = html_response(conn, 302)
    assert response =~ "/messages"
  end

  test "DELETE /messages/:id", %{conn: conn} do
    {:ok, message} = Messages.Message.create(%{subject: "Deleteme", body: "Deleted body"})

    {:ok, _} =
      Messages.SlackMessage.create(%{
        slack_timestamp: "timestamp",
        slack_message: "message",
        slack_channel: "channel",
        message_id: message.id
      })

    expect(Messages.SlackMock, :delete, fn _ -> {:ok, "{\"ok\": true}"} end)
    conn = delete(conn, Routes.message_path(conn, :delete, message))
    response = html_response(conn, 302)
    assert response =~ "/messages"
  end

  test "GET /messages/:id", %{conn: conn} do
    {:ok, message} = Messages.Message.create(%{subject: "Show", body: "Show me the message"})
    conn = get(conn, Routes.message_path(conn, :show, message))
    response = html_response(conn, 200)
    assert response =~ message.subject
    assert response =~ message.body
  end
end

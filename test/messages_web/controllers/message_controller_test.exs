defmodule MessagesWeb.MessageControllerTest do
  use MessagesWeb.ConnCase

  test "GET /messages", %{conn: conn} do
    conn = get(conn, Routes.message_path(conn, :index))
    assert html_response(conn, 200) =~ "List of messages"
  end

  test "GET /messages (with data)", %{conn: conn} do
    { :ok, message1 } = Messages.Message.create(
      %{ subject: "Message 1 subject", body: "Message 1 body"})
    { :ok, message2 } = Messages.Message.create(
      %{ subject: "Message 2 subject", body: "Message 2 body"})
    conn = get(conn, Routes.message_path(conn, :index))
    response = html_response(conn, 200)
    assert response =~ message1.subject
    assert response =~ message2.subject
  end

  test "GET /new", %{conn: conn} do
    conn = get(conn, Routes.message_path(conn, :new))
    response = html_response(conn, 200)
    assert response =~ "Subject:"
    assert response =~ "Body:"
  end

  # test "POST /messages", %{conn: conn} do
  #   data = %{ subject: "Subject", body: "Message body"}
  #   conn = post(conn, Routes.message_path(conn, :create), message: data)
  #   response = html_response(conn, 302)
  #   assert response =~ "/messages"
  # end
end

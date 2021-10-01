defmodule MessagesWeb.MessageController do
  use MessagesWeb, :controller
  alias Messages.Messenger

  def index(conn, _params) do
    messages = Messenger.all_messages()
    render(conn, "index.html", messages: messages)
  end

  def create(conn, %{ "message" => message_params }) do
    case Messenger.create_message(message_params) do
      { :ok, _message } ->
        redirect(conn, to: Routes.message_path(conn, :index))
      { :error, changeset } ->
        render(conn, "new.html", message: changeset)
    end
  end

  def show(conn, %{ "id" => id}) do
    message = Messenger.get_message!(id)
    render(conn, "show.html", message: message)
  end

  def new(conn, _params) do
    message = Messenger.new_message()
    render(conn, "new.html", message: message)
  end

  def delete(conn, %{"id" => id}) do
    case Messages.Messenger.delete_message(id) do
      {:ok, _message} -> redirect(conn, to: Routes.message_path(conn, :index))
    end
  end
end

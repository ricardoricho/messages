defmodule MessagesWeb.MessageController do
  use MessagesWeb, :controller

  def index(conn, _params) do
    messages = Messages.Repo.all(Messages.Message)
    render(conn, "index.html", messages: messages)
  end

  # def create(conn, %{ message: message_params }) do
  #   case Messages.Message.create(message_params) do
  #     { :ok, _message } ->
  #       redirect(conn, to: Routes.messanges_path(conn, :index))
  #     { :error, changeset } ->
  #       render(conn, "new.html", message: changeset)
  #   end
  # end

  def new(conn, _params) do
    message = Messages.Message.new()
    render(conn, "new.html", message: message)
  end
end

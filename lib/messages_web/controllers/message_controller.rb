defmodule MessagesWeb.MessageController do
  use MessagesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

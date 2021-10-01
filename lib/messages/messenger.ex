defmodule Messages.Messenger do
  def create_message(attrs) do
    %Messages.Message{}
    |> Messages.Message.changeset(attrs)
    |> Messages.Repo.insert
    |> create_in_slack
  end

  def all_messages() do
    Messages.Message.all()
  end

  def new_message() do
    %Messages.Message{}
    |> Messages.Message.changeset(%{})
  end

  def get_message!(id) do
    Messages.Message.get!(id)
  end

  def delete_message(id) do
    get_message!(id)
    |> Messages.Message.delete
    |> delete_from_slack
  end

  def create_in_slack({:ok, message}) do
    slack_app().push(message)
  end

  def delete_from_slack({:ok, message}) when message.slack_message do
    slack_app().delete(message.slack_message.id)
  end

  def delete_from_slack({:ok, message}) do
    {:ok, message}
  end

  def slack_app do
    Application.get_env(:messages, :slack_app)
  end
end

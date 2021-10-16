defmodule Messages.Messenger do
  def create_message(attrs) do
    %Messages.Message{}
    |> Messages.Message.changeset(attrs)
    |> Messages.Repo.insert()
    |> create_in_slack
  end

  def all_messages() do
    Messages.Message.not_deleted()
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
    |> Messages.Message.soft_delete()
    |> delete_from_slack
  end

  def create_in_slack({:ok, message}) do
    slack_app().push(message)
  end

  def create_in_slack({:error, message}) do
    {:error, message}
  end

  def delete_from_slack({:ok, message}) do
    case Messages.SlackMessage.find_by_message(message) do
      nil ->
        {:ok, message}

      slack_message ->
        slack_app().delete(slack_message)
    end
  end

  def slack_app do
    Application.get_env(:messages, :slack_app)
  end
end

defmodule Messages.Messenger do
  def create_message(attrs) do
    %Messages.Message{}
    |> Messages.Message.changeset(attrs)
    |> Messages.Repo.insert
    # |> Messages.Slack.create
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
  end
end

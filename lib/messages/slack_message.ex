defmodule Messages.SlackMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slack_messages" do
    field :slack_timestamp, :string
    field :slack_message, :string
    field :slack_channel, :string

    belongs_to :message, Messages.Message
  end

  def changeset(slack_message, params) do
    slack_message
    |> cast(params, [:slack_timestamp, :slack_message, :message_id, :slack_channel])
    |> validate_required([:slack_timestamp, :slack_message, :slack_channel])
  end

  def create(params) do
    %Messages.SlackMessage{}
    |> changeset(params)
    |> Messages.Repo.insert
  end

  def push_confirmation({:ok, slack_response}, message_id) do
    case Jason.decode(slack_response.body) do
      {:ok, response} ->
        Messages.SlackMessage.changeset(%Messages.SlackMessage{},
          %{ "slack_timestamp" => response["ts"],
             "slack_channel" => response["channel"],
             "slack_message" => slack_response.body,
             "message_id" => message_id})
      # {:error, response} -> {:error, response}
    end
  end

  def delete_confirmation({:ok, slack_response}) do
    case Jason.decode(slack_response.body) do
      {:ok, response} -> true = response["ok"]
    end
  end
end

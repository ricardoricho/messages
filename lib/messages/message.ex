defmodule Messages.Message do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "messages" do
    field :subject, :string
    field :body, :string
    field :deleted_at, :utc_datetime

    has_one :slack_message, Messages.SlackMessage
  end

  def create(attrs) do
    %Messages.Message{}
    |> changeset(attrs)
    |> Messages.Repo.insert()
  end

  def all() do
    Messages.Message
    |> Messages.Repo.all()
  end

  def not_deleted() do
    Messages.Message
    |> Ecto.Query.where([message], is_nil(message.deleted_at))
    |> Messages.Repo.all()
  end

  def changeset(message, params) do
    message
    |> cast(params, [:subject, :body, :deleted_at])
    |> validate_required([:subject, :body])
  end

  def get!(id) do
    Messages.Message
    |> Messages.Repo.get!(id)
  end

  def delete(message) do
    Messages.Repo.delete(message)
  end

  def short_body(message, max) do
    String.length(message.body)
    |> min(max)
    |> adjust_slice_parameters(0, message.body)
  end

  def slack_format(message) do
    "Subject: #{message.subject} \n#{message.body}"
  end

  def soft_delete(message, time \\ DateTime.utc_now()) do
    Messages.Message.changeset(message, %{deleted_at: time})
    |> Messages.Repo.update()
  end

  defp adjust_slice_parameters(max, 0, message) do
    String.slice(message, 0, max) <> "..."
  end
end

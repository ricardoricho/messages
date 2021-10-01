defmodule Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :subject, :string
    field :body, :string
  end

  def create(attrs) do
    %Messages.Message{}
    |> changeset(attrs)
    |> Messages.Repo.insert
  end

  def all() do
    Messages.Message
    |> Messages.Repo.all()
  end

  def changeset(message, params) do
    message
    |> cast(params, [:subject, :body])
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

  defp adjust_slice_parameters(max, 0, message) do
    String.slice(message, 0, max) <> "..."
  end
end

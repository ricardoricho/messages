defmodule Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Messages.Repo

  schema "messages" do
    field :subject, :string
    field :body, :string
  end

  def create(attrs) do
    %Messages.Message{}
    |> changeset(attrs)
    |> Repo.insert
  end

  def all do
    %Messages.Message{}
    |> Repo.all()
  end

  def new do
    %Messages.Message{}
    |> changeset(%{})
  end

  def changeset(message, params) do
    message
    |> cast(params, [:subject, :body])
    |> validate_required([:subject, :body])
  end

  def get_message!(id) do
    Messages.Message
    |> Messages.Repo.get!(id)
  end

  def delete_message(message) do
    Messages.Repo.delete(message)
  end
end

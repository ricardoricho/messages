defmodule Messages.Message do
  use Ecto.Schema
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

  def changeset(message, params) do
    message
    |> Ecto.Changeset.cast(params, [:subject, :body])
    |> Ecto.Changeset.validate_required([:subject, :body])
  end
end

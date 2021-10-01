defmodule Messages.Repo.Migrations.CreateSlackMessages do
  use Ecto.Migration

  def change do
    create table(:slack_messages) do
      add :message_id, references(:messages)
      add :slack_timestamp, :string
      add :slack_message, :text
      add :slack_channel, :string
    end

    create unique_index(:slack_messages, [:message_id])
  end
end

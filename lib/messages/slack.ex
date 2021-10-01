defmodule Messages.Slack do
  use GenServer
  alias Messages.SlackWeb

  def init(state) do
    {:ok, state}
  end

  def start_link(options) do
    GenServer.start_link(__MODULE__, "", options)
  end

  def push({:ok, message}) do
    GenServer.call(Messages.Slack, {:push, message})
    {:ok, message}
  end

  def delete(message_id) do
    GenServer.call(Messages.Slack, {:delete, message_id})
    {:ok, message_id}
  end

  def handle_call({:push, message}, _from, state) do
    { :reply,
      SlackWeb.push(message.id, Messages.Message.slack_format(message)),
      state }
  end

  def handle_call({:delete, message_id}, _from, state) do
    {:reply, SlackWeb.delete(message_id), state }
  end

  def handle_cast({:push, message}, state) do
    SlackWeb.push(message.id, Messages.Message.slack_format(message))
    {:noreply, state }
  end

  def handle_cast({:delete, message_id}, state) do
    SlackWeb.delete(message_id)
    {:noreply, state}
  end
end

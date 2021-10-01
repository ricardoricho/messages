defmodule Messages.SlackWeb do
  def authorization_token() do
    Application.get_env(:messages, :slack_token)
  end

  def http_client do
    Application.get_env(:messages, :http_client)
  end

  def url do
    Application.get_env(:messages, :slack_url)
  end

  def push(message_id, text) do
    http_client().post(post_message_url(), payload(text), post_headers())
    |> Messages.SlackMessage.push_confirmation(message_id)
    |> Messages.Repo.insert
  end

  def delete(timestamp) do
    http_client().post(delete_message_url(), delete_payload(timestamp), post_headers())
    |> Messages.SlackMessage.delete_confirmation
  end

  def post_headers do
    [{ "Content-Type","application/json" },
     { "Accept", "application/json;charset=UTF-8"},
     { "Authorization","Bearer #{authorization_token()}" }]
  end

  def payload(message) do
    "{ \"channel\": \"messenger\", \"text\": \"#{message}\"}"
  end

  def delete_payload(timestamp) do
    "{ \"channel\": \"messenger\", \"ts\": \"#{timestamp}\"}"
  end

  def post_message_url do
    url() <> "chat.postMessage"
  end

  def delete_message_url do
    url() <> "chat.delete"
  end
end

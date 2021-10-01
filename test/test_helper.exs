ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Messages.Repo, :manual)
# Mox
Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)
Mox.defmock(Messages.SlackMock, for: Messages.SlackBehaviour)
Application.put_env(:messages, :http_client, HTTPoison.BaseMock)
# Slack
# Application.put_env(:messages, :slack_url, "https://slack.com/api/")
Application.put_env(:messages, :slack_app, Messages.SlackMock)
Application.put_env(:messages, :slack_url, "slack_api_url")

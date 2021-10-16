defmodule Messages.SlackWebTest do
  import Mox
  use ExUnit.Case, async: true
  alias Messages.SlackWeb

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Messages.Repo, :auto)
  end

  describe "url" do
    test "get value from application environment" do
      assert "slack_api_url" = SlackWeb.url()
    end
  end

  test "push" do
    {:ok, response} =
      Jason.encode(%{
        ok: true,
        channel: "C1H9RESGL",
        ts: "1503435956.000247",
        message: %{
          text: "Here's a message for you",
          username: "ecto1",
          bot_id: "B19LU7CSY",
          type: "message",
          subtype: "bot_message",
          ts: "1503435956.000247"
        }
      })

    http_response = %HTTPoison.Response{body: response}
    expect(HTTPoison.BaseMock, :post, fn _url, _payload, _headers -> {:ok, http_response} end)
    {:ok, message} = Messages.Message.create(%{subject: "subject", body: "body"})
    {:ok, slack_message} = SlackWeb.push(message.id, Messages.Message.slack_format(message))
    assert "1503435956.000247" = slack_message.slack_timestamp
    assert "C1H9RESGL" == slack_message.slack_channel
  end

  test "delete" do
    http_response = %HTTPoison.Response{
      body: "{\"ok\": true,\"channel\": \"C024BE91L\",\"ts\": \"1401383885.000061\"}"
    }

    expect(HTTPoison.BaseMock, :post, fn _url, _payload, _headers -> {:ok, http_response} end)
    {:ok, message} = Messages.Message.create(%{subject: "subject", body: "body"})

    {:ok, slack_message} =
      Messages.SlackMessage.create(%{
        slack_timestamp: "1503435956.000247",
        slack_message: "Slack message",
        slack_channel: "C02BE91L",
        message_id: message.id
      })

    response = SlackWeb.delete(slack_message)
    assert("C024BE91L" = response["channel"])
  end
end

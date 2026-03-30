class WebhookJob < ApplicationJob
  queue_as :medium

  # Retry failed webhooks up to 3 times with exponential backoff (1s, 2s, 4s)
  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  # There are 3 types of webhooks, account, inbox and agent_bot
  def perform(url, payload, webhook_type = :account_webhook)
    Webhooks::Trigger.execute(url, payload, webhook_type)
  end
end

# frozen_string_literal: true

class TelegramChatCreateJob < ApplicationJob
  queue_as :default

  def perform(chat_id, client)
    Telegram::Chat::Create.call(chat_id, client)
  end
end

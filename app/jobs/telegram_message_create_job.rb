# frozen_string_literal: true

class TelegramMessageCreateJob < ApplicationJob
  queue_as :default

  def perform(message, client)
    user_id = message.sender.user_id if message.sender.is_a?(TD::Types::MessageSender::User)
    chat_id = message.chat_id

    Telegram::Message::Create.call(message, client)
    sleep(3)
    TelegramUserCreateJob.perform_later(user_id, message)
    sleep(3)
    TelegramChatCreateJob.perform_later(chat_id, message)
  end
end

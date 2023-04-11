# frozen_string_literal: true

class Telegram::Message::Create
  class << self
    def call(message)
      message_id = message[:message_id]

      chat_id = message[:chat_id]
      user_id = message[:user_id]

      datetime = message[:datetime]
      text = message[:text]
      reply_to_message_id = message[:reply_to_message_id]

      sync_chat(chat_id)
      sync_user(user_id)

      create_message(chat_id, user_id, message_id, datetime, text, reply_to_message_id)
    end

    private

    def sync_chat(chat_id)
      Telegram::Chat::CreateJob.perform_later(chat_id)
    end

    def sync_user(user_id)
      Telegram::User::CreateJob.perform_later(user_id)
    end

    def create_message(chat_id, user_id, message_id, datetime, text, reply_to_message_id)
      Message.create!(
        message_id: message_id,
        user_id: user_id,
        chat_id: chat_id,
        datetime: datetime,
        reply_to_message_id: reply_to_message_id,
        text: text
      )
    end
  end
end

# frozen_string_literal: true

class Telegram::Message::Create
  class << self
    def call(message)
      chat_id = message[:chat_id]
      user_id = message[:user_id]

      sync_chat(chat_id)
      sync_user(user_id)

      create_message(message)
    end

    private

    def sync_chat(chat_id)
      chat = Chat.find_by(chat_id: chat_id)
      Telegram::Chat::CreateJob.perform_later(chat_id) unless chat
    end

    def sync_user(user_id)
      user = User.find_by(user_id: user_id)
      Telegram::User::CreateJob.perform_later(user_id) unless user
    end

    def create_message(message)
      Message.create!(
        message_id: message[:message_id],
        user_id: message[:user_id],
        chat_id: message[:chat_id],
        datetime: message[:datetime],
        reply_to_message_id: message[:reply_to_message_id],
        text: message[:text]
      )
    end
  end
end

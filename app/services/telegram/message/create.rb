# frozen_string_literal: true

class Telegram::Message::Create
  class << self
    def call(message, client)
      message_id = message.id
      chat_id = message.chat_id
      user_id = message.sender.user_id
      datetime = Time.at(message.date)
      text = message_text(message.content)

      chat = find_or_create_chat(chat_id, client)
      user = find_or_create_user(user_id, client)

      create_message(chat, user, message_id, datetime, text)
    end

    private

    def message_text(content)
      if content.is_a?(TD::Types::MessageContent::Text)
        content.text.text
      elsif content.is_a?(TD::Types::MessageContent::Photo)
        'Photo'
      else
        'Undefined format (video, voice, etc..)'
      end
    end

    def find_or_create_chat(chat_id, client)
      Chat.find_by(chat_id: chat_id) || Telegram::Chat::Create.call(chat_id, client)
    end

    def find_or_create_user(user_id, client)
      User.find_by(user_id: user_id) || Telegram::User::Create.call(user_id, client)
    end

    def create_message(chat, user, message_id, datetime, text)
      chat.messages.create!(
        message_id: message_id,
        user_id: user.id,
        chat_id: chat.id,
        datetime: datetime,
        text: text.to_json
      )
    end
  end
end

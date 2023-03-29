# frozen_string_literal: true

class Telegram::Message::Create
  class << self
    def call(message)
      message_id = message.id
      chat_id = message.chat_id
      user_id = message.sender.user_id if message.sender.is_a?(TD::Types::MessageSender::User)

      datetime = Time.at(message.date)
      text = message_text(message.content)
      reply_to_message_id = message.reply_to_message_id
      chat = find_or_create_chat(chat_id)
      user = find_or_create_user(user_id)

      create_message(chat, user, message_id, datetime, text, reply_to_message_id)
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

    def find_or_create_chat(chat_id)
      Chat.find_by(chat_id: chat_id)
    end

    def find_or_create_user(user_id)
      User.find_by(user_id: user_id)
    end

    def create_message(chat, user, message_id, datetime, text, reply_to_message_id)
      chat.messages.create!(
        message_id: message_id,
        user_id: user.id,
        chat_id: chat.id,
        datetime: datetime,
        reply_to_message_id: reply_to_message_id,
        text: text.to_json
      )
    end
  end
end

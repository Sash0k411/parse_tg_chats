# frozen_string_literal: true

PUB_CHAT_PREFIX = '-100'

class Bot::Listener < Bot::Base
  class << self

    def listen
      client_listen.connect
      client_listen.on(TD::Types::Update::NewMessage) do |update|
        process(update.message)
      end
    end

    def process(message)
      return unless is_chat?(message)

      Telegram::User::CreateJob.perform_later(message.sender.user_id)
      Telegram::Chat::CreateJob.perform_later(message.chat_id)

      Telegram::Message::CreateJob.perform_later(message_data(message)) # message params to hash
    end

    private

    def is_chat?(message)
      message.sender.is_a?(TD::Types::MessageSender::User) && message.chat_id.to_s.include?(PUB_CHAT_PREFIX)
    end

    def message_data(message)
      {
        message_id: message.id,
        chat_id: message.chat_id,
        user_id: message.sender.user_id,
        datetime: Time.at(message.date),
        text: message.content.text.text.to_s,
        reply_to_message_id: message.reply_to_message_id
      }
    end
  end
end

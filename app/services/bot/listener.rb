# frozen_string_literal: true

PUB_CHAT_PREFIX = '-100'

class Bot::Listener < Bot::Base
  class << self
    def listen
      current_client = client
      current_client.connect
      current_client.on(TD::Types::Update::NewMessage) do |update|
        process(update.message)
      end
    end

    private

    def client
      TD::Client.new(database_directory: ENV['TG_DB_PATH_LISTENER'],
                     api_hash: ENV['TG_API_HASH_LISTENER'],
                     api_id: ENV['TG_API_ID_LISTENER'])
    end

    def telegram_phone
      ENV['TG_PHONE_LISTENER']
    end

    def process(message)
      return unless is_chat?(message)

      Telegram::Message::CreateJob.perform_later(message_data(message))
    end

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

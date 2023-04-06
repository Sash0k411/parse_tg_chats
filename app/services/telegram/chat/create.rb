# frozen_string_literal: true

class Telegram::Chat::Create
  class << self
    def call(chat_id)
      Bot::Parser.request do |client|
        client.get_chat(chat_id: chat_id).then do |chat_info|
          Chat.create!(
            chat_id: chat_info.id,
            title: chat_info.title,
            photo: chat_info.photo.to_json,
            chat_type: chat_info.type.to_s
          )
        end
      end
    end
  end
end

# frozen_string_literal: true

class Telegram::Chat::CreateJob < ApplicationJob
  queue_as :parser

  def perform(chat_id)
    chat = Chat.find_by(chat_id: chat_id)
    if chat.nil?
      Telegram::Chat::Create.call(chat_id)
    else
      puts "Chat with chat_id=#{chat_id} already exists in the database"
    end
  end
end

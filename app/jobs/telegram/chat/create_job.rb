# frozen_string_literal: true

class Telegram::Chat::CreateJob < ApplicationJob
  queue_as :parser

  def perform(chat_id)
    Telegram::Chat::Create.call(chat_id)
  end
end

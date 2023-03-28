# frozen_string_literal: true

class TelegramUserCreateJob < ApplicationJob
  queue_as :default

  def perform(user_id, client)
    Telegram::User::Create.call(user_id, client)
  end
end

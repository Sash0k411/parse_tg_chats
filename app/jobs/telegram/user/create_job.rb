# frozen_string_literal: true

class Telegram::User::CreateJob < ApplicationJob
  queue_as :parser

  def perform(user_id)
    Telegram::User::Create.call(user_id)
  end
end

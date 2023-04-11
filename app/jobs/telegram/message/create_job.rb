# frozen_string_literal: true

class Telegram::Message::CreateJob < ApplicationJob
  queue_as :listener

  def perform(message)
    Telegram::Message::Create.call(message)
  end
end

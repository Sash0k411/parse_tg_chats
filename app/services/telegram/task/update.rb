# frozen_string_literal: true

class Telegram::Task::Update
  def initialize(message)
    @message = message
  end

  def call
    data = {
      chat_id: @message.chat_id,
      user_id: @message.sender.user_id
    }

    Telegram::Task.all.update(input: data)
  end
end

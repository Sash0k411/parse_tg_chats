# frozen_string_literal: true

class CommandJob < ApplicationJob
  queue_as :default

  def perform(task)
    service_class = task[:service_class].safe_constantize
    user_id = task[:input]['user_id']
    chat_id = task[:input]['chat_id']
    begin
      if service_class == Telegram::User::Create
        service_class.call(user_id)
      else
        service_class.call(chat_id)
      end
      task.update(status: :processed)
    rescue StandardError => e
      task.update(status: :failed, output: { error: e.message })
    ensure
      task.update(status: :not_used, input: nil)
    end
  end
end

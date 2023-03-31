# frozen_string_literal: true

class Telegram::Task < ApplicationRecord
  self.table_name = 'telegram_tasks'
  enum title: {
    save_user: 'save_user',
    save_chat: 'save_chat'
  }

  attr_reader :title, :status, :input, :output, :service_class
end

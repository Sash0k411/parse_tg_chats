# frozen_string_literal: true

class Chat < ApplicationRecord
  has_many :messages

  validates :chat_id, uniqueness: true
end

# frozen_string_literal: true

class Chat < ApplicationRecord
  has_many :messages, foreign_key: :chat_id
  has_many :users, through: :messages

  validates :chat_id, uniqueness: true
end

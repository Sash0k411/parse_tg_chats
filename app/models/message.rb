# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :message_id, uniqueness: true
  validates :user, presence: true
  validates :chat, presence: true
end

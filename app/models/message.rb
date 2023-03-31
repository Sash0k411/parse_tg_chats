# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat, optional: true
  belongs_to :user, optional: true

  validates :message_id, uniqueness: true
end

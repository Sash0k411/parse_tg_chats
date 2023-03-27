# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user
end

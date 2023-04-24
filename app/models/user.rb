# frozen_string_literal: true

class User < ApplicationRecord
  has_many :messages, foreign_key: :user_id
  has_many :chats, through: :messages

  validates :user_id, uniqueness: true
end

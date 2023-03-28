# frozen_string_literal: true

class User < ApplicationRecord
  has_many :messages

  validates :user_id, uniqueness: true
end

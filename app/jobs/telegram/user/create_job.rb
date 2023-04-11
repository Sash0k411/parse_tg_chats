# frozen_string_literal: true

class Telegram::User::CreateJob < ApplicationJob
  queue_as :parser

  def perform(user_id)
    user = User.find_by(user_id: user_id)
    if user.nil?
      Telegram::User::Create.call(user_id)
    else
      puts "User with user_id=#{user_id} already exists in the database"
    end
  end
end

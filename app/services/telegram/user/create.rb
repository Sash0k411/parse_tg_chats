# frozen_string_literal: true

class Telegram::User::Create
  class << self
    def call(user_id)
      Bot::Parser.request do |client|
        client.get_user(user_id: user_id).then do |user_info|
          User.create!(
            user_id: user_info.id,
            first_name: user_info.first_name,
            last_name: user_info.last_name,
            username: user_info.username,
            phone_number: user_info.phone_number,
            profile_photo: user_info.profile_photo.to_json
          )
        end.rescue do |e|
          raise e
        end
      end
    end
  end
end

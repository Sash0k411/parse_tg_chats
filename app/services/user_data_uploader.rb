
class UserDataUploader
  def initialize(message)
    @message = message
    @client = Bot.client
  end

  def save_user_data
    sender = @message.sender
    user_id = sender.user_id

    user = @client.get_user(user_id: user_id).value
    user.then do |user_info|
      User.create!(
        user_id: user_info.id,
        first_name: user_info.first_name,
        last_name: user_info.last_name,
        username: user_info.username,
        phone_number: user_info.phone_number,
        user_type: user_info.type,
        profile_photo: user_info.profile_photo.to_json
        )
    end
  end
end
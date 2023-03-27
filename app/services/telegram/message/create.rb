
class Telegram::Message::Create
  class << self
    def call(message, client)
    message_id = message.id
    chat_id = message.chat_id
    user_id = message.sender.user_id
    datetime = Time.at(message.date)

    if message.content.is_a?(TD::Types::MessageContent::Text)
      text = message.content.text.text
    elsif message.content.is_a?(TD::Types::MessageContent::Photo)
      text = 'Photo'
    else
      text = 'Undefined format (video, voice, etc..)'
    end

    chat = Chat.find_by(chat_id: chat_id)
    user = User.find_by(user_id: user_id)

    if chat.nil?
      chat = Telegram::Chat::Create.call(chat_id, client)
    end

    if user.nil?
      user = Telegram::User::Create.call(user_id, client)
    end

    chat.messages.create!(
      message_id: message_id,
      user_id: user.id,
      chat_id: chat.id,
      datetime: datetime,
      text: text.to_json
    )
    end
  end
end

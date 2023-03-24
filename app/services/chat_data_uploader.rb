
class ChatDataUploader

  def initialize(message)
    @message = message
    @client = Bot.client
  end

  def save_chat_data
    chat_id = @message.chat_id

    chat = @client.get_chat(chat_id: chat_id).value
    chat.then do |chat_info|
      Chat.create!(
        chat_id: chat_info.id,
        title: chat_info.title,
        photo: chat_info.photo.to_json,
        reply_markup_message_id: chat_info.reply_markup_message_id,
        chat_type: chat_info.type.to_s
      )
    end
  end
end

TD.configure do |config|
  config.lib_path = ENV['TG_LIB_PATH']
  config.client.api_id = ENV['TG_API_ID']
  config.client.api_hash = ENV['TG_API_HASH']
  config.client.use_test_dc = false
  config.client.system_language_code = 'en'
  config.client.device_model = 'MACOS'
  config.client.system_version = '1'
  config.client.application_version = '0.1'
  config.client.database_directory = ENV['TG_DB_PATH']
end

TD::Api.set_log_verbosity_level(2)

class Bot
  class << self
    def client
      @@client ||= TD::Client.new
    end

    def listen
      auth_state = nil
      client.on(TD::Types::Update::AuthorizationState) do |update|
        puts update.authorization_state

        auth_state = case update.authorization_state
                     when TD::Types::AuthorizationState::WaitPhoneNumber
                       :wait_phone_number
                     when TD::Types::AuthorizationState::WaitCode
                       :wait_code
                     when TD::Types::AuthorizationState::WaitPassword
                       :wait_password
                     when TD::Types::AuthorizationState::Ready
                       :ready
                     else
                       nil
                     end
      end

      client.on(TD::Types::Update::NewMessage) do |update|
        process(update.message)
      end

      client.connect

      # Daemon
      loop do
        # puts "looping"

        case auth_state
        when :wait_phone_number
          puts 'Please, enter your phone number:'
          phone = ENV['TG_PHONE']
          client.set_authentication_phone_number(phone_number: phone, settings: nil).wait
        when :wait_code
          puts 'Please, enter code from SMS:'
          code = STDIN.gets.strip
          client.check_authentication_code(code: code).wait
          client.get_me.rescue { |err| puts "error: #{err}" }.wait
        when :ready
          break
        end
        sleep 2
      end
    end

    def process(message)
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
          chat = ChatDataUploader.new(message).save_chat_data
        end

        if user.nil?
          user = UserDataUploader.new(message).save_user_data
        end

        chat.messages.create!(
          message_id: message_id,
          user_id: user.id,
          chat_id: chat.id,
          datetime: datetime,
          text: text.to_json
       )
    end
    private
  end
end

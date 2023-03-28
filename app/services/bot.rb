# frozen_string_literal: true

PUB_CHAT_PREFIX = '-100'

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
                     end
      end

      client.on(TD::Types::Update::NewMessage) do |update|
        process(update.message, client)
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

    def process(message, client)
      return unless is_chat?(message)

      TelegramMessageCreateJob.perform_now(message, client)
    end

    private

    def is_chat?(message)
      message.sender.user_id.present? && message.chat_id.to_s.include?(PUB_CHAT_PREFIX)
    end
  end
end

# frozen_string_literal: true

TD.configure do |config|
  config.lib_path = ENV['TG_LIB_PATH']
  config.client.use_test_dc = false
  config.client.system_language_code = 'en'
  config.client.device_model = 'MACOS'
  config.client.system_version = '1'
  config.client.application_version = '0.1'
end

TD::Api.set_log_verbosity_level(2)

class Bot::Base
  class << self
    def authorize
      current_client = client
      auth_state = nil

      current_client.on(TD::Types::Update::AuthorizationState) do |update|
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

      current_client.connect

      # Daemon
      loop do
        # puts "looping"

        case auth_state
        when :wait_phone_number
          puts 'Please, enter your phone number:'
          phone = telegram_phone
          current_client.set_authentication_phone_number(phone_number: phone, settings: nil).wait
        when :wait_code
          puts 'Please, enter code from SMS:'
          code = $stdin.gets.strip
          current_client.check_authentication_code(code: code).wait
        when :ready
          break
        end
        sleep 2
      end
    end
  end
end

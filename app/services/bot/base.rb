# frozen_string_literal: true

TD.configure do |config|
  config.lib_path = ENV['TG_LIB_PATH']
  config.client.use_test_dc = false
  config.client.system_language_code = 'en'
  config.client.device_model = 'MACOS'
  config.client.system_version = '1'
  config.client.application_version = '0.1'
  config.client.api_id = ENV['TG_API_ID_LISTEN']
  config.client.api_hash = ENV['TG_API_HASH_LISTEN']
  config.client.database_directory = ENV['TG_DB_PATH_LISTEN']
end

TD::Api.set_log_verbosity_level(0)

class Bot::Base
  class << self
    def client_listen
      @@client_listen ||= TD::Client.new
    end

    def client_parse
      @@client_parse ||= TD::Client.new(database_directory: ENV['TG_DB_PATH_PARSE'],
                                        api_hash: ENV['TG_API_HASH_PARSE'],
                                        api_id: ENV['TG_API_ID_PARSE'])
    end


    def authorize
      auth_state = nil
      client_listen.on(TD::Types::Update::AuthorizationState) do |update|
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

      client_listen.on(TD::Types::Update::NewMessage) do |update|
        process(update.message)
      end

      client_listen.connect

      # Daemon
      loop do
        # puts "looping"

        case auth_state
        when :wait_phone_number
          puts 'Please, enter your phone number:'
          phone = ENV['TG_PHONE_LISTEN']
          client_listen.set_authentication_phone_number(phone_number: phone, settings: nil).wait
        when :wait_code
          puts 'Please, enter code from SMS:'
          code = $stdin.gets.strip
          client_listen.check_authentication_code(code: code).wait
        when :ready
          break
        end
        sleep 2
      end
    end

    def auth
      auth_state = nil
      client_parse.on(TD::Types::Update::AuthorizationState) do |update|
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

      client_parse.connect

      # Daemon
      loop do
        # puts "looping"

        case auth_state
        when :wait_phone_number
          puts 'Please, enter your phone number:'
          phone = ENV['TG_PHONE_PARSE']
          client_parse.set_authentication_phone_number(phone_number: phone, settings: nil).wait
        when :wait_code
          puts 'Please, enter code from SMS parse client:'
          code = $stdin.gets.strip
          client_parse.check_authentication_code(code: code).wait
        when :ready
          break
        end
        sleep 2
      end
    end
  end
end


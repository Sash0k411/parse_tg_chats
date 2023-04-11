# frozen_string_literal: true

class Bot::Parser < Bot::Base
  class << self
    def request(&block)
      current_client = client
      current_client.connect.then do
        block.call(current_client)
      ensure
        current_client.dispose
      end
    rescue StandardError => e
      puts e
    end

    def client
      TD::Client.new(database_directory: ENV['TG_DB_PATH_PARSE'],
                     api_hash: ENV['TG_API_HASH_PARSE'],
                     api_id: ENV['TG_API_ID_PARSE'],
                     lib_path: ENV['TG_LIB_PATH_PARSE'])
    end
  end
end

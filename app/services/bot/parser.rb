# frozen_string_literal: true

class Bot::Parser < Bot::Base
  class << self
    def request(&block)
      current_client = client
      current_client.connect.then do
        block.call(current_client)
        current_client.dispose
      end.rescue do |e|
        current_client.dispose
        raise e
      end
    end

    private

    def client
      TD::Client.new(database_directory: ENV['TG_DB_PATH_PARSER'],
                     api_hash: ENV['TG_API_HASH_PARSER'],
                     api_id: ENV['TG_API_ID_PARSER'],
                     lib_path: ENV['TG_LIB_PATH_PARSER'],
                     phone_number: ENV['TG_PHONE_PARSER'])
    end
  end
end

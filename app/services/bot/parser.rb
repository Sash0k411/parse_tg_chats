# frozen_string_literal: true

class Bot::Parser < Bot::Base
  class << self
    def request(&block)
      block.call(client_parse)
    end
  end
end

# frozen_string_literal: true

module Admin
  class MessagesController < ApplicationController
    def index
      messages = Message.all
      @messages = paginate(messages)
    end

    private

    def paginate(messages)
      messages.order(created_at: :desc).page(params[:page])
    end
  end
end

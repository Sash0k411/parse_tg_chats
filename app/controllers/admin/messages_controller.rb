module Admin
  class MessagesController < ApplicationController
    def index
      messages = Message.all
      @messages = paginate(messages)
    end

    private

    def paginate(messages)
      messages.order('created_at DESC').page(params[:page]).per(params[:per])
    end

  end
end
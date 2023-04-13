# frozen_string_literal: true

class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.bigint :chat_id, index: true
      t.string :title
      t.string :chat_type
      t.string :photo
      t.bigint :reply_markup_message_id, index: true

      t.timestamps
    end
  end
end

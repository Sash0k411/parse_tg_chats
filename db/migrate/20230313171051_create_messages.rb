# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.bigint :message_id, index: true
      t.bigint :chat_id, index: true
      t.bigint :user_id, index: true
      t.bigint :reply_to_message_id, index: true
      t.datetime :datetime
      t.json :text

      t.timestamps
    end
  end
end

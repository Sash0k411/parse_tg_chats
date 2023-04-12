# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.bigint :message_id
      t.bigint :chat_id
      t.bigint :user_id
      t.bigint :reply_to_message_id
      t.datetime :datetime
      t.json :text

      t.timestamps
    end

    add_index :messages, :message_id
    add_index :messages, :chat_id
    add_index :messages, :user_id
    add_index :messages, :reply_to_message_id
  end
end

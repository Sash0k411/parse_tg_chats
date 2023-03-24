class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.bigint :chat_id
      t.string :title
      t.string :chat_type
      t.string :photo
      t.bigint :reply_markup_message_id

      t.timestamps
    end
  end
end

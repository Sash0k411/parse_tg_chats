class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :message_id
      t.integer :chat_id
      t.integer :sender_id
      t.datetime :datetime
      t.text :text
      t.text :original_message

      t.timestamps
    end
  end
end

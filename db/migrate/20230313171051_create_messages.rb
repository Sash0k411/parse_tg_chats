class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :message_id
      t.bigint :chat_id
      t.bigint :sender_id
      t.datetime :datetime
      t.json :text
      t.text :original_message

      t.timestamps
    end
  end
end

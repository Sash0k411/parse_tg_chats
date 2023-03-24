class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.bigint :message_id
      t.bigint :chat_id
      t.bigint :user_id
      t.datetime :datetime
      t.json :text

      t.timestamps
    end
  end
end

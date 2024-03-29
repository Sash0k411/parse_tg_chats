# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.bigint :user_id, index: true
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :phone_number
      t.json :profile_photo

      t.timestamps
    end
  end
end

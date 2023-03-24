class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.bigint :user_id
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :phone_number
      t.string :user_type
      t.json :profile_photo

      t.timestamps
    end
  end
end

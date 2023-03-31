# frozen_string_literal: true

class TelegramTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :telegram_tasks do |t|
      t.string :title
      t.string :status
      t.json :input
      t.json :output
      t.string :service_class

      t.timestamps
    end
  end
end

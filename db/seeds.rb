# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Telegram::Task.create!(title: :save_user, status: :not_used, service_class: Telegram::User::Create)
Telegram::Task.create!(title: :save_chat, status: :not_used, service_class: Telegram::Chat::Create)

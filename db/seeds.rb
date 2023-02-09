# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Destroying existing records..."
User.destroy_all
puts "Done deletion"

puts "Creating 4 new Users..."

User.create!(username: "SarahR", email: "sarah@email.com", password: "123456")
User.create(username: "Tanao", email: "tanner@email.com", password: "123456")
User.create(username: "Dani", email: "danielle@email.com", password: "123456")
User.create(username: "Eevie", email: "yvonne@email.com", password: "123456")

puts "Done creating users"

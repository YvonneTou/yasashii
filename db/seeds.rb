# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

SYMPTOMS = [
  "back pain",
  "chest pain",
  "earache",
  "headache",
  "toothache",
  "rash",
  "Chills",
  "Fever",
  "Numbness",
  "Light-headed",
  "Dizzy",
  "Dry mouth",
  "Nausea",
  "Sneezing",
  "Coughing",
  "Shortness of breath",
  "Drowsiness",
  "Cold sweats",
  "Thirst",
  "Tiredness",
  "Trouble breathing",
  "Trouble hearing",
  "Hearing loss",
  "sounds are too loud",
  "Ringing ears",
  "Unusual bowel movement",
  "Hurts to pee",
  "Foggy memory",
  "Blurred vision",
  "Double vision",
  "Trouble sleeping",
  "Loss of smell",
  "Slurred speech",
  "Itchy",
  "Difficulty swallowing",
  "Loss of taste",
  "Difficulty walking",
  "Difficulting writing"
]


puts "Destroying existing records..."
Connection.destroy_all
User.destroy_all
puts "Done deletion"

puts "Creating 4 new Users..."

User.create!(username: "SarahR", email: "sarah@email.com", password: "123456")
User.create(username: "Tanao", email: "tanner@email.com", password: "123456")
User.create(username: "Dani", email: "danielle@email.com", password: "123456")
User.create(username: "Eevie", email: "yvonne@email.com", password: "123456")

puts "Done creating users"

puts "Creating 8 connections..."

User.all.each do |user|
  Connection.create!({
    user: user,
    clinic: Clinic.all.sample,
    start_time: DateTime.new(2023,2,11,14,18,0),
    end_time: DateTime.new(2023,2,11,14,23,0),
    appointment_date: DateTime.new(2023,2,14,11,0,0),
    symptoms: [SYMPTOMS.sample, SYMPTOMS.sample],
    info: "I require wheelchair access.",
    status: 1
  })

  Connection.create!({
    user: user,
    clinic: Clinic.all.sample,
    start_time: DateTime.new(2023,2,8,14,18,0),
    end_time: DateTime.new(2023,2,8,14,23,0),
    appointment_date: DateTime.new(2023,2,9,8,30,0),
    symptoms: [SYMPTOMS.sample, SYMPTOMS.sample],
    info: "I am hard of hearing.",
    status: 3
  })
end

puts "Done creating connections"

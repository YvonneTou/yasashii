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

puts "Creating 10 new Clinics..."

Clinic.create!(
  name: 'Meguro Dermatology',
  location: '1F 3-10-49 Knot Hanabusayama.
  Kamiosaki, Shinagawa. 141-0021 Tokyo',
  hours: '9:30-19:00',
  phone_number: '03-6409-6079',
  email: 'info@meguro-derm.jp',
  description: 'We are doing medical treatment for patients with general skin diseases such as atopic dermatitis, urticaria, eczema, athletes foot, acne, water warts, warts, herpes, herpes zoster, rash, moles, seborrheic dermatitis, and alopecia areata.',
)

Clinic.create!(
  name: 'Meguromirai Internal Medicine Clinic',
  location: '〒141-0021 2-13-26 Kamiosaki Shinagawa-ku, Tokyo Maple top building 3F',
  hours: '9:00-18:00',
  phone_number: '050-3146-4574',
  email: 'info@meguro-clinic.net',
  description: 'Regular internal medical issues starting from the common cold
  Diabetes
  Respiratory medicine COPD・Bronchial asthma・Sleep apnea syndrome etc
  High blood pressure, Dyslipidemia, Hyperuricemia, Fatty liver disease and other lifestyle-related diseases/ illnesses',
)

Clinic.create!(
  name: 'Meguro Ladies Clinic',
  location: '1-3-15 Meguro City, Tokyo REID-C Meguro West Building B1F',
  hours: '10:00-19:00',
  phone_number: 'Line: 目黒レディースクリニック',
  email: 'info@meguro-ladies.com',
  description: 'We are doing timing therapy, artificial insemination, and in vitro fertilization. There are also ovary dogs such as ovarian age measurement. We are focusing on treating those who have few eggs such as premature menopause.',
)

Clinic.create!(
  name: 'Meguro Ear',
  location: '153-0063 Tokyo, Meguro City, Meguro, 2 Chome-9-5 Blossom Meguro 3F',
  hours: '9:30-17:30',
  phone_number: '03-3490-4187',
  email: 'info@meguro-jibika.com',
  description: 'From babies and children to matures, if you are suffering from ear (external ear canalitis, otitis media, hearing loss), nose (allergenic rhin rhinitis, sinusitis), throat (amycitis, laryngitis, abnormality of vocal cords), please come to the hospital. Sign language is also possible."'
)

Clinic.create!(
  name: 'Sakurai Orthopedic Surgical Clinic',
  location: '1 Chome-15-6 Yutenji, Meguro City, Tokyo 153-0052',
  hours: '9:00-18:30',
  phone_number: '03-5723-8166',
  email: 'info@sakurai-ortho.jp',
  description: ''
)

Clinic.create!(
  name: '',
  location: '',
  hours: '',
  phone_number: '',
  email: '',
  description: ''
)

Clinic.create!(
  name: '',
  location: '',
  hours: '',
  phone_number: '',
  email: '',
  description: ''
)

Clinic.create!(
  name: '',
  location: '',
  hours: '',
  phone_number: '',
  email: '',
  description: ''
)

Clinic.create!(
  name: '',
  location: '',
  hours: '',
  phone_number: '',
  email: '',
  description: ''
)

Clinic.create!(
  name: '',
  location: '',
  hours: '',
  phone_number: '',
  email: '',
  description: ''
)

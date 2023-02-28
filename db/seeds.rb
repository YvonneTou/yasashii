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
Clinic.destroy_all
User.destroy_all
puts "Done deletion"

puts "Creating 4 new Users..."

sarah = {
  file: "https://res.cloudinary.com/df7gbyhfx/image/upload/v1677485847/wdvks78cnylhnmuic7ox.png",
  username: "SarahR",
  email: "sarah@email.com",
  password: "123456",
  lastname: "Rollins",
  firstname: "Sarah"
}

tanner = {
  file: "https://res.cloudinary.com/df7gbyhfx/image/upload/v1677485871/gzjpt9oeinyz4wq1qo6t.png",
  username: "Tanao",
  email: "tanner@email.com",
  password: "123456",
  lastname: "Maxwell",
  firstname: "Tanner"
}

dani = {
  file: "https://res.cloudinary.com/df7gbyhfx/image/upload/v1677485861/eew9vywfuyfq4faoyev5.png",
  username: "Dani",
  email: "danielle@email.com",
  password: "123456",
  lastname: "Matsumoto",
  firstname: "Danielle"
}

yvonne = {
  file: "https://res.cloudinary.com/df7gbyhfx/image/upload/v1677485835/hw40x8plypk3bvvxh9qp.jpg",
  username: "Eevie",
  email: "yvonne@email.com",
  password: "123456",
  lastname: "Tou",
  firstname: "Yvonne"
}

users = [yvonne, sarah, dani, tanner]

def create_users(user)
  file = URI.open(user[:file])

  new_user = User.new(
    {
      username: user[:username],
      email: user[:email],
      password: user[:password],
      lastname: user[:lastname],
      firstname: user[:firstname],
    }
  )

  new_user.photo.attach(io: file, filename: "#{user[:name]}.jpg", content_type: "image/jpg")
  p "This is new_user.photo: #{new_user.photo.key}"
  new_user.save
end

users.each_with_index do |user, index|
  create_users(user)
  puts "Created #{index + 1} user#{index.zero? ? '' : 's'}"
end

puts "Done creating users"

puts "Creating 10 new Clinics..."

derm = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098274/f8ohtzopvp39syrgiurl.jpg",
  name: 'Meguro Dermatology',
  location: '3-10-49 Knot Hanabusayama 1F, Kamiosaki, Shinagawa, Tokyo',
  hours: '9:30-19:00',
  phone_number: '818030161151',
  email: 'info@meguro-derm.jp',
  description: 'We are doing medical treatment for patients with general skin diseases such as atopic dermatitis, urticaria, eczema, athletes foot, acne, water warts, warts, herpes, herpes zoster, rash, moles, seborrheic dermatitis, and alopecia areata.',
}

mirai = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098571/b5pc0fz1xznoyjbf5c6n.png",
  name: 'Meguromirai Internal Medicine Clinic',
  location: '〒141-0021 2-13-26 Kamiosaki Shinagawa-ku, Tokyo Maple top building 3F',
  hours: '9:00-18:00',
  phone_number: '818030161151',
  email: 'info@meguro-clinic.net',
  description: 'Regular internal medical issues starting from the common cold
  Diabetes
  Respiratory medicine COPD・Bronchial asthma・Sleep apnea syndrome etc
  High blood pressure, Dyslipidemia, Hyperuricemia, Fatty liver disease and other lifestyle-related diseases/ illnesses',
}

ladies = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098430/tqehxzorgix6eygvqnlj.jpg",
  name: 'Meguro Ladies Clinic',
  location: '1-3-15 Meguro City, Tokyo REID-C Meguro West Building B1F',
  hours: '10:00-19:00',
  phone_number: '818030161151',
  email: 'info@meguro-ladies.com',
  description: 'We are doing timing therapy, artificial insemination, and in vitro fertilization. There are also ovary dogs such as ovarian age measurement. We are focusing on treating those who have few eggs such as premature menopause.',
}

ear = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098325/luxbijrgqhnaicuiphd1.jpg",
  name: 'Meguro Ear',
  location: '153-0063 Tokyo, Meguro City, Meguro, 2 Chome-9-5 Blossom Meguro 3F',
  hours: '9:30-17:30',
  phone_number: '818030161151',
  email: 'info@meguro-jibika.com',
  description: 'From babies and children to matures, if you are suffering from ear (external ear canalitis, otitis media, hearing loss), nose (allergenic rhin rhinitis, sinusitis), throat (amycitis, laryngitis, abnormality of vocal cords), please come to the hospital. Sign language is also possible."'
}

sakurai = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098620/aepj0yo0b2tndmspkjbc.jpg",
  name: 'Sakurai Orthopedic Surgical Clinic',
  location: '1 Chome-15-6 Yutenji, Meguro City, Tokyo 153-0052',
  hours: '9:00-18:30',
  phone_number: '818030161151',
  email: 'info@sakurai-ortho.jp',
  description: 'Specializing in hyaluronic acid injection, steroid injections, and osteoarthritis treatment. Dr. Sakurai has amazing injection skills.'
}

mental = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098517/ggkqixqzd0lxlewkidgs.jpg",
  name: 'Meguro Ekimae Mental Clinic',
  location: '141-0021 Tokyo, Shinagawa City, Kamiosaki, 4 Chome-4-6 Meguro MT Building',
  hours: '9:00-18:30',
  phone_number: '818030161151',
  email: 'info@meguro-mental.jp',
  description: ''
}

sakoda = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098682/fz8jcbrtkxsdsvxhonrp.jpg",
  name: 'Meguro Sakoda Orthopedics',
  location: '153-0063 Tokyo, Meguro City, Meguro, 3 Chome-10-13 Ootori Estate Building 3F',
  hours: '9:00-18:30',
  phone_number: '818030161151',
  email: 'info@sakoda-seikei.com',
  description: 'We will provide medical care about the specialized fields of orthopedic and rehabilitation departments.'
}

hira = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098393/zquhpwiksc8zt3rwoifi.jpg",
  name: 'Hiramoto Eye Clinic',
  location: '153-0064 Tokyo, Meguro City, Shimomeguro, 2 Chome-20-22 Sun Palace Meguro 101',
  hours: '10:00-18:30',
  phone_number: '818030161151',
  email: 'info@hirmamoto-ganka.com',
  description: 'If your eyes are not feeling well or if there is anything wrong with your appearance, please feel free to come. Thank you.'
}

utaan = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676097011/bkdtbp3vq8fj4znuqytw.jpg",
  name: 'Utaan Acupuncture Orthopedic Clinic',
  location: '153-0064 Tokyo, Meguro City, Shimomeguro, 2 Chome-16-11 Meguro Point 302',
  hours: '10:00-20:00',
  phone_number: '818030161151',
  email: 'info@shianshimoncare.com',
  description: 'Based on thorough counseling, we approach not only the affected area but also the cause of the symptoms, so you can get a faster and reliable effect and maintain a good condition.'
}

kei = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676097047/ngen2jpcysdekyfuypwy.jpg",
  name: 'KEI Acupuncture',
  location: '153-0064 Tokyo, Meguro City, Shimomeguro, 1 Chome-4-6 Royal Meguro 203',
  hours: '10:00-18:00',
  phone_number: '818030161151',
  email: 'info@kei-acupuncture.com',
  description: 'We will provide peace of mind and satisfactory treatment. Do you have any symptoms like this? ・Stubborn back pain, hip pain ・Stiff neck, stiff shoulders, ・Eye fatigue, headache, ・Insomnia, ups and downs in mood Please experience our hospitals acupuncture and chiropractic once, where you can graduate from many years of upset'
}

clinics = [derm, mirai, ladies, ear, sakurai, mental, sakoda, hira, utaan, kei]

def create_clinics(clinic)
  file = URI.open(clinic[:file])
  p "This is clinic[:file]: #{clinic[:file]}"

  new_clinic = Clinic.new(
    {
    name: clinic[:name],
    location: clinic[:location],
    hours: clinic[:hours],
    phone_number: clinic[:phone_number],
    email: clinic[:email],
    description: clinic[:description]
    }
  )

  new_clinic.photo.attach(io: file, filename: "#{clinic[:name]}.jpg", content_type: "image/jpg")
  p "This is new_clinic.photo: #{new_clinic.photo.key}"
  new_clinic.save
end

clinics.each_with_index do |clinic, index|
  create_clinics(clinic)
  puts "Created #{index + 1} clinic#{index.zero? ? '' : 's'}"
end

puts 'Done creating 10 clinics'

puts "Creating three connections per user (#{User.all.count * 3} connections)..."

User.all.each do |user|
  Connection.create!(
    {
      user: user,
      clinic: Clinic.all.sample,
      start_time: DateTime.new(2023, 2, 11, 14, 18, 0),
      end_time: DateTime.new(2023, 2, 11, 14, 23, 0),
      appt_date: DateTime.new(2023, 2, 14, 11, 0, 0),
      symptoms: ["dizziness", "shortness of breath", "fatigue"],
      info: "I require wheelchair access.",
      status: 1
    }
  )

  Connection.create!(
    {
      user: user,
      clinic: Clinic.all.sample,
      start_time: DateTime.new(2023, 2, 1, 14, 18, 0),
      end_time: DateTime.new(2023, 2, 1, 14, 23, 0),
      appt_date: DateTime.new(2023, 2, 2, 8, 30, 0),
      symptoms: ["cough", "fever", "loss of taste"],
      info: "I might have the Rona.",
      status: 3
    }
  )

  Connection.create!(
    {
      user: user,
      clinic: Clinic.all.sample,
      start_time: DateTime.new(2023, 1, 6, 14, 18, 0),
      end_time: DateTime.new(2023, 1, 6, 14, 23, 0),
      appt_date: DateTime.new(2023, 1, 8, 8, 30, 0),
      symptoms: ["itchiness", "acne", "oozing"],
      info: "I require ointment.",
      status: 3
    }
  )
end

puts "Done creating connections"

puts "Creating sample conversation for each connection (5 messages x #{Connection.all.count} connections = #{Connection.all.count * 5} messages)"

Connection.all.each do |connection|
  Message.create!(
    {
      connection: connection,
      content: "Thank you reaching #{connection.clinic.name}. We can accept your appointment at that date and time.",
      sender_type: "clinic",
      sender: connection.clinic
    }
  )

  Message.create!(
    {
      connection: connection,
      content: "Great, thank you so much!",
      sender_type: "user",
      sender: connection.user
    }
  )

  Message.create!(
    {
      connection: connection,
      content: "Your appointment is confirmed for #{connection.appt_date.strftime("%A, %B%e at %H:%M")}",
      sender_type: "clinic",
      sender: connection.clinic
    }
  )

  Message.create!(
    {
      connection: connection,
      content: "I'll see you then. Thanks for your help!",
      sender_type: "user",
      sender: connection.user
    }
  )

  Message.create!(
    {
      connection: connection,
      content: "Thank you for your booking. Please take care. Excuse me.",
      sender_type: "clinic",
      sender: connection.clinic
    }
  )
end

puts "Done creating messages"

puts "Adding specialties for clinics"

def specialty(clinic, symptom)
  clinic = Clinic.find_by(name: clinic).id
  Specialty.create!(
    symptom_id: symptom,
    clinic_id: clinic
  )
end

# clinics = [derm, mirai, ladies, ear, sakurai, mental, sakoda, hira, utaan, kei]

specialty('Meguro Ear', 7)
specialty('Meguro Ear', 8)
specialty('Sakurai Orthopedic Surgical Clinic', 10)
specialty('Meguro Ekimae Mental Clinic', 1)
specialty('Meguro Ekimae Mental Clinic', 5)
specialty('Meguro Sakoda Orthopedics', 8)
specialty('Meguro Dermatology', 4)
specialty('Meguromirai Internal Medicine Clinic', 10)
specialty('Meguro Ladies Clinic', 5)
specialty('Utaan Acupuncture Orthopedic Clinic', 8)
specialty('KEI Acupuncture', 1)

puts "Done adding specialties to clinics!"

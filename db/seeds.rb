# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "nokogiri"
require "open-uri"

# scraping locations (70 total) and names (70 total) of clinics
# limited amount of clinics to 30
url_one = "https://www.alljapanrelocation.com/living-guides/hospitals/"
html_one = URI.open(url_one)
doc_one = Nokogiri::HTML.parse(html_one)

elements_names = doc_one.search('.hospital-info h3').take(30)
elements_locations = doc_one.search('.fa-map-marker + a').take(30)

names = elements_names.map do |element|
  element.text.strip
end

locations = elements_locations.map do |element|
  element.text.strip
end

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
  name: 'Shinagawa Dermatology',
  location: '3-10-49 Knot Hanabusayama 1F, Kamiosaki, Shinagawa, Tokyo',
  hours: '9:30-19:00',
  phone_number: '818030161151',
  email: 'info@shinagawa-derm.jp',
  description: 'We are doing medical treatment for patients with general skin diseases such as atopic dermatitis,
  urticaria, eczema, athletes foot, acne, water warts, warts, herpes, herpes zoster, rash, moles,
  seborrheic dermatitis, and alopecia areata.'
}

mirai = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098571/b5pc0fz1xznoyjbf5c6n.png",
  name: 'Shinagawa Mirai Internal Medicine Clinic',
  location: '141-0021 2-13-26 Kamiosaki Shinagawa-ku, Tokyo Maple Top Building 3F',
  hours: '9:00-18:00',
  phone_number: '818030161151',
  email: 'info@shinagawa-clinic.net',
  description: 'Regular internal medical issues starting from the common cold. Diabetes・Respiratory medicine COPD・
  Bronchial asthma・Sleep apnea syndrome etc. High blood pressure, Dyslipidemia, Hyperuricemia, Fatty liver disease
  and other lifestyle-related diseases/ illnesses'
}

ladies = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098430/tqehxzorgix6eygvqnlj.jpg",
  name: 'Meguro Ladies Clinic',
  location: '1-3-15 Meguro City, Tokyo REID-C Meguro West Building B1F',
  hours: '10:00-19:00',
  phone_number: '818030161151',
  email: 'info@meguro-ladies.com',
  description: 'We are doing timing therapy, artificial insemination, and in vitro fertilization. There are also ovary
  tests such as ovarian age measurement. We are focusing on treating those who have few eggs such as premature menopause.'
}

ear = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098325/luxbijrgqhnaicuiphd1.jpg",
  name: 'Meguro Ear',
  location: '153-0063 Tokyo, Meguro City, Meguro, 2 Chome-9-5 Blossom Meguro 3F',
  hours: '9:30-17:30',
  phone_number: '818030161151',
  email: 'info@meguro-jibika.com',
  description: 'From babies and children to matures, if you are suffering from ear (external ear canalitis,
  otitis media, hearing loss), nose (allergenic rhin rhinitis, sinusitis), throat
  (amycitis, laryngitis, abnormality of vocal cords), please come to the hospital. Sign language is also possible.'
}

sakurai = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098620/aepj0yo0b2tndmspkjbc.jpg",
  name: 'Sakurai Orthopedic Surgical Clinic',
  location: '1 Chome-15-6 Yutenji, Meguro City, Tokyo 153-0052',
  hours: '9:00-18:30',
  phone_number: '818030161151',
  email: 'info@sakurai-ortho.jp',
  description: 'Specializing in hyaluronic acid injection, steroid injections, and osteoarthritis treatment.
  Dr. Sakurai has amazing injection skills.'
}

mental = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098517/ggkqixqzd0lxlewkidgs.jpg",
  name: 'Shinagawa Ekimae Mental Clinic',
  location: '141-0021 Tokyo, Shinagawa City, Kamiosaki, 4 Chome-4-6 Meguro MT Building',
  hours: '9:00-18:30',
  phone_number: '818030161151',
  email: 'info@shinagawa-mental.jp',
  description: 'We are happy to provide comprehensive counseling, psychotherapy and psychology services for children and families.
  Our growing team of counselors and psychologists can work with parents and children to address concerns around
  mental health, behaviour and childhood development.'
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
  description: 'If your eyes are not feeling well or if there is anything wrong with your appearance,
  please feel free to come. Thank you.'
}

utaan = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676097011/bkdtbp3vq8fj4znuqytw.jpg",
  name: 'Utaan Acupuncture Orthopedic Clinic',
  location: '153-0064 Tokyo, Meguro City, Shimomeguro, 2 Chome-16-11 Meguro Point 302',
  hours: '10:00-20:00',
  phone_number: '818030161151',
  email: 'info@shianshimoncare.com',
  description: 'Based on thorough counseling, we approach not only the affected area but also the cause of the symptoms,
  so you can get a faster and reliable effect and maintain a good condition.'
}

kei = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676097047/ngen2jpcysdekyfuypwy.jpg",
  name: 'KEI Acupuncture',
  location: '153-0064 Tokyo, Meguro City, Shimomeguro, 1 Chome-4-6 Royal Meguro 203',
  hours: '10:00-18:00',
  phone_number: '818030161151',
  email: 'info@kei-acupuncture.com',
  description: 'We will provide peace of mind and satisfactory treatment. Do you have any symptoms like this?
  ・Stubborn back pain, hip pain ・Stiff neck, stiff shoulders, ・Eye fatigue, headache, ・Insomnia, ups and downs in mood
  Please experience our hospitals acupuncture and chiropractic once, where you can graduate from many years of upset'
}

nagakura = {
  file: "http://res.cloudinary.com/df7gbyhfx/image/upload/v1677893168/cseufavo4rw8msetzblh.png",
  name: 'Nagakura Jibika Allergy Clinic',
  location: '141-0021 Tokyo, Shinagawa City, Kamiosaki, 2 Chome-13-26 Maple Top Building 5F',
  hours: '9:00-18:00',
  phone_number: '818030161151',
  email: 'info@nagakura-ac.com',
  description: 'As an otolaryngologist, an allergy specialist, and a sports doctor, I would like to provide patients with sufficient explanations and information, create an environment where they can receive treatment with peace of mind, and work on medical treatment.'
}

clinics = [derm, mirai, ladies, ear, sakurai, mental, sakoda, hira, utaan, kei, nagakura]

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

puts 'Creating 30 more clinics for Mapbox map'

clinic_photos = ["http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098393/zquhpwiksc8zt3rwoifi.jpg",
                 "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098682/fz8jcbrtkxsdsvxhonrp.jpg",
                 "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098517/ggkqixqzd0lxlewkidgs.jpg",
                 "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098620/aepj0yo0b2tndmspkjbc.jpg",
                 "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098325/luxbijrgqhnaicuiphd1.jpg",
                 "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098430/tqehxzorgix6eygvqnlj.jpg",
                 "http://res.cloudinary.com/df7gbyhfx/image/upload/v1676098571/b5pc0fz1xznoyjbf5c6n.png"]

clinic_hours = ['10:00-18:00', '10:00-20:00', '11:00-18:30', '9:00-18:30', '10:30-19:00', '9:30-17:00']

clinic_phone_num = ['0248-23-2230', '0278-22-2777', '099-297-5830', '093-582-7217', '045-251-4740', '06-6488-9133',
                    '0155-29-4515', '011-612-4181', '077-562-0730', '029-886-4531']

clinic_email = ['clinic@care.com', 'yasashii@health.com', 'tokyoclinic@yasashii.care',
                'tkyclinic@naika.com', 'dainibyouin@yasashii.care', 'healthfirst@sante.org']

clinic_desc = ["We are an organized medical team offering diagnostic, therapeutic, and preventive outpatient services.
  Please contact us to book an appointment and discuss treatment plans.", "Our hospital operates on an outpatient
  referral system. Please bring your referral from a clinic or doctor's office when you visit.", "We are an
  interdisciplinary practice that has been providing healthcare to our community since 1995"]

def create_clinics_map(a_name, a_location, hours, phone, mail, desc, photo)
  file = URI.open(photo.sample)

  new_clinic = Clinic.new(
    {
      name: a_name,
      location: a_location,
      hours: hours.sample,
      phone_number: phone.sample,
      email: mail.sample,
      description: desc.sample
    }
  )

  new_clinic.photo.attach(io: file, filename: "#{a_name}.jpg", content_type: "image/jpg")
  new_clinic.save
end

names.zip(locations).each do |name, location|
  create_clinics_map(name, location, clinic_hours, clinic_phone_num, clinic_email, clinic_desc, clinic_photos)
end

puts 'Done creating clinics for Mapbox map'

puts "Creating three connections per user (#{User.all.count * 3} connections)..."

User.all.each do |user|
  Connection.create!(
    {
      user: user,
      clinic: Clinic.all.sample,
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

puts "Adding symptoms and specialties for clinics"

def add_symptoms(symptom)
  Symptom.create!(
    location: symptom[:location],
    symptom_en: symptom[:symptom_en],
    symptom_jp: symptom[:symptom_jp]
  )
end

symptoms = [
  head1 = {
    location: 'head',
    symptom_en: 'headache',
    symptom_jp: '頭痛'
  },
  head2 = {
    location: 'head',
    symptom_en: 'hair loss',
    symptom_jp: '髪の毛が抜けてきている'
  },
  head3 = {
    location: 'head',
    symptom_en: 'dizzines',
    symptom_jp: '立ちくらみがする'
  },
  ear1 = {
    location: 'ear',
    symptom_en: 'tinnitus',
    symptom_jp: '耳鳴りがする'
  },
  ear2 = {
    location: 'ear',
    symptom_en: 'stuffy ears',
    symptom_jp:'耳が詰まった感じがする'
  },
  neck1 = {
    location: 'neck',
    symptom_en: 'neck swelling',
    symptom_jp: '首の周りが腫れている'
  },
  neck2 = {
    location: 'neck',
    symptom_en: 'stiff neck',
    symptom_jp: '首こりがある'
  },
  mouth1 = {
    location: 'mouth',
    symptom_en: 'toothache',
    symptom_jp: '歯の痛みがある'
  },
  mouth2 = {
    location: 'mouth',
    symptom_en: 'cavity',
    symptom_jp: '虫歯'
  },
  throat = {
    location: 'throat',
    symptom_en: 'sore throat',
    symptom_jp: 'のどの痛みがある'
  },
  allergy1 = {
    location: 'allergy',
    symptom_en: 'allergic rhinitis',
    symptom_jp: 'アレルギー性鼻炎'
  },
  allergy2 = {
    location: 'allergy',
    symptom_en: 'coughing and sneezing',
    symptom_jp: '咳とくしゃみ'
  },
  nose1 = {
    location: 'nose',
    symptom_en: 'runny nose',
    symptom_jp: '鼻水が出る'
  },
  nose2 = {
    location: 'nose',
    symptom_en: 'nose bleed',
    symptom_jp: '鼻血が出ている'
  },
  eye = {
    location: 'eye',
    symptom_en: 'eyeball popped out',
    symptom_jp: '目玉が飛び出している'
  },
  stomach1 = {
    location: 'stomach',
    symptom_en: 'diarrhea',
    symptom_jp: '下痢'
  },
  stomach2 = {
    location: 'stomach',
    symptom_en: 'constipation',
    symptom_jp: '便秘'
  },
  uterus1 = {
    location: 'uterus',
    symptom_en: 'inconsistent period',
    symptom_jp: '生理周期がおかしい'
  },
  vagina = {
    location: 'vagina',
    symptom_en: 'vaginal pain',
    symptom_jp: '女性器の痛み'
  },
  lung = {
    location: 'lung',
    symptom_en: 'dry cough',
    symptom_jp: '空咳が出る'
  }
]

symptoms.each do |symptom|
  add_symptoms(symptom)
end

# clinics = [derm, mirai, ladies, ear, sakurai, mental, sakoda, hira, utaan, kei, nagakura]

def specialty(clinic, symptom)
  # clinic_id = Clinic.find_by(name: clinic[:name]).id
  # symptom_id = Symptom.find_by(symptom_en: symptom[:symptom_en]).id
  Specialty.create!(
    clinic_id: Clinic.find_by(name: clinic[:name]).id,
    symptom_id: Symptom.find_by(symptom_en: symptom[:symptom_en]).id
  )
end

specialty(ear, ear1)
specialty(ear, ear2)
specialty(sakurai, neck2)
specialty(mental, head1)
specialty(mental, head3)
specialty(sakoda, neck1)
specialty(derm, head2)
specialty(mirai, throat)
specialty(ladies, head3)
specialty(utaan, neck1)
specialty(kei, head1)
specialty(nagakura, allergy1)
specialty(nagakura, allergy2)
specialty(nagakura, nose1)

puts "Done adding specialties to clinics!"

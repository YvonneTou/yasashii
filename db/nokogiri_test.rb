require "nokogiri"
require "open-uri"

# scraping locations (70 total) and names (70 total) of clinics
# amount of items limited to 20
url_one = "https://www.alljapanrelocation.com/living-guides/hospitals/"
html_one = URI.open(url_one)
doc_one = Nokogiri::HTML.parse(html_one)

elements_one_name = doc_one.search('.hospital-info h3').take(20)
elements_one_location = doc_one.search('.fa-map-marker + a').take(20)

names = elements_one_name.map do |element|
  element.text.strip
end

locations = elements_one_location.map do |element|
  element.text.strip
end

puts locations


# scraping locations in Shinagawa (30 locations)
# url_two = "https://yaokami.jp/tokyo/a13109/"
# html_two = URI.open(url_two)
# doc_two = Nokogiri::HTML.parse(html_two)

# elements_two_location = doc_two.search('.result-address')

# locations_shinagawa = elements_two_location.map do |element|
#   address = element.text.strip
# end

# puts locations_shinagawa.count

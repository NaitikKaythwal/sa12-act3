require 'httparty'
api_key = "6b7216d5848d3e13a72bed77"
source = "USD"
target = "INR"

url = "https://v6.exchangerate-api.com/v6/#{api_key}/latest/#{source}"

response = HTTParty.get(url, headers: {"User-Agent" => "Request"})
currency_data = JSON.parse(response.body)
target = "INR"
rate = currency_data["conversion_rates"]["#{target}"]
puts "Enter amount to be converted from #{source} to #{target}:"
amount = gets.chomp.to_f
conversion = amount * rate
puts conversion

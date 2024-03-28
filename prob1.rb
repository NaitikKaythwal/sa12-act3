require 'httparty'
require 'json'

api_key = "763f1dbecb41431592141508242803"
city_name = "London"

hourly_temps = []

24.times do |hour|
    url = "https://api.weatherapi.com/v1/current.json?key=#{api_key}&q=#{city_name}&aqi=no"
    response = HTTParty.get(url)

    if response.code == 200
        weather_data = JSON.parse(response.body)
        temp_f = weather_data["current"]["temp_f"]
        humidity = weather_data["current"]["humidity"]
        conditions = weather_data["current"]["condition"]["text"]
        hourly_temps << temp_f
        puts "Hour #{hour + 1}"
        puts "Current weather in #{city_name}:"
        puts "Temperature: #{temp_f}°F"
        puts "Humidity: #{humidity}%"
        puts "Conditions: #{conditions}"
    else
        puts "Failed to retrieve weather data. Response code: #{response.code}"
    end

    sleep(3600) # Sleep for an hour, repeated over 24 hours to collect the average data since weatherapi provides only current data and not historic.
end

average_temp = hourly_temps.sum / hourly_temps.size.to_f
puts "#{average_temp.round(2)}°F"
puts "\nAverage temperature in #{city_name} over the past 24 hours:"

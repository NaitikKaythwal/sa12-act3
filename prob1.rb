require 'httparty'
require 'json'
require 'date'

api_key = "763f1dbecb41431592141508242803"
city_name = "London"

def fetch_current_weather(api_key, city_name)
    url = "https://api.weatherapi.com/v1/current.json?key=#{api_key}&q=#{city_name}&aqi=no"
    response = HTTParty.get(url)

    if response.code == 200
      weather_data = JSON.parse(response.body)
      display_current_weather(weather_data)
    else
      puts "Failed to retrieve current weather data. Response code: #{response.code}"
    end
end

def display_current_weather(weather_data)
    current = weather_data["current"]
    puts "\nCurrent weather in #{weather_data['location']['name']}:"
    puts "Temperature: #{current['temp_f']}°F"
    puts "Humidity: #{current['humidity']}%"
    puts "Conditions: #{current['condition']['text']}"
end

puts "Fetching weather data for #{city_name}..."

fetch_current_weather(api_key, city_name)

yesterday = (Date.today - 1).strftime('%Y-%m-%d')

url = "http://api.weatherapi.com/v1/history.json?key=#{api_key}&q=#{city_name}&dt=#{yesterday}"

response = HTTParty.get(url)


puts "\nHistorical data to calculate the average temperature every hour for 24 hours:"
if response.code == 200
    weather_data = JSON.parse(response.body)

    hourly_temps = weather_data["forecast"]["forecastday"][0]["hour"].map do |hour|
        {
            time: hour["time"],
            temp_f: hour["temp_f"]
        }
    end

    hourly_temps.each_with_index do |temp, index|
        puts "\nHour #{index + 1}"
        puts "Time: #{temp[:time]}, Temperature: #{temp[:temp_f]}°F"
    end

    average_temp = hourly_temps.sum { |temp| temp[:temp_f] } / hourly_temps.size.to_f
    puts "\nAverage temperature in #{city_name} on #{yesterday}: #{average_temp.round(2)}°F"
else
    puts "Failed to retrieve weather data. Response code: #{response.code}"
end

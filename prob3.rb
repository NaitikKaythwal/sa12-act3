require 'httparty'

api_key = "FMu2zFpU95f73VwK9WcNDDIEx3tAdpx1"
url = "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&apikey=#{api_key}"
response = HTTParty.get(url, headers: {"User-Agent" => "Request"})
if response.success?
  events = JSON.parse(response.body)["_embedded"]["events"]

  if events.empty?
    puts "No upcoming events found in the United States."
  else
    puts "Upcoming events in the United States:"
    events.each_with_index do |event, index|
      puts "#{index + 1}: #{event['name']}"
      puts "Date: #{event['dates']['start']['localDate']} @ #{event['dates']['start']['localTime']} at #{event['_embedded']['venues'][0]['name']}"

      puts "URL: #{event['url']}\n\n"
    end
  end
else
  puts "Failed to retrieve events. Error: #{response.body}"
end

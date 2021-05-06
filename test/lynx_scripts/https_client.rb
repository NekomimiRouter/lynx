# frozen_string_literal: true

HttpsClient.new.get("https://api.ip.sb/geoip") do |response|
  unless response.body
    puts response.status
    puts response.msg
  else
    puts response.body
  end
end

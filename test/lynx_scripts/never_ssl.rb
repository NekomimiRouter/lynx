# frozen_string_literal: true

HttpsClient.new.get("http://neverssl.com/") do |response|
  unless response.body
    puts response.status
    puts response.msg
  else
    puts response.body
  end
end

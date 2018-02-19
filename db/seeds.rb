case Rails.env
when 'development'

  start_time = Time.now

  logins = []
  100.times { logins << [*('a'..'z')].sample(10).join }
  pp logins

  ips = []
  50.times { ips << IPAddr.new(rand(2**32), Socket::AF_INET).to_s }
  pp ips

  title = 'A' * 75
  pp title

  content = 'Z' * 30_000
  pp content

  rates = [1, 2, 3, 4, 5]

  200_000.times do |i|
    %x[curl -H "CONTENT_TYPE: application/vnd.api+JSON" -H "ACCEPT: application/vnd.api+json" -X POST -d '{"title": #{title}, "content": #{content}, "login": #{logins.sample}, "ip": #{ips.sample}}' http://0.0.0.0:3000/create]
    rates.sample.times do
      %x[curl -H "CONTENT_TYPE: application/vnd.api+JSON" -H "ACCEPT: application/vnd.api+json" -X POST -d '{"post_id": #{i}, "rate": #{rates.sample}}' http://0.0.0.0:3000/rate]
    end
    pp i
  end

  finish_time = Time.now
  pp "time: #{finish_time - start_time}"
  # `curl -H "CONTENT_TYPE: application/vnd.api+JSON" -H "ACCEPT: application/vnd.api+json" -X POST -d '{"top_number": 1}' http://0.0.0.0:3000/top`
  # `curl -H "ACCEPT: application/vnd.api+json" -X GET http://0.0.0.0:3000/popular_ip`
end

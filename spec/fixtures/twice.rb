require_relative 'fixture_helper.rb'

HeyYou.new(channel: testing_key("twice_1"), sleep: 0.5).listen do |payload|
  puts "Got payload: #{payload}"
end


HeyYou.new(channel: testing_key("twice_2"), sleep: 0.5).listen do |payload|
  puts "Got payload: #{payload}"
end

puts "I ran"

sleep 10

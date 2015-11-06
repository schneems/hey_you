require_relative 'fixture_helper.rb'

HeyYou.new(channel: testing_key("once"), sleep: 0.5).listen do |payload|
  puts "Got payload: #{payload}"
end

puts "I ran"

sleep 10

# HeyYou

Use postgres to [LISTEN/NOTIFY](http://www.postgresql.org/docs/9.1/static/sql-notify.html) to trigger custom events.

## Why?

Let's say you've got a fleet of machines running code, you only want to trigger a custom event on all of them or one of them. With `HeyYou` it is super easy. What kind of event? Maybe it is for debugging or maybe it is for housekeeping. For example you could take a heap dump off of a running server and upload it to S3 using this library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hey_you'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hey_you

## Usage

Somewhere in your code you can run:

```
HeyYou.new.listen do |payload|
  puts "Hey I got a message: #{payload}"
end
```

This will spin up a new thread and periodically check for a notification, this won't block execution by default.

Then in another console, you can run:

```
HeyYou.new.notify("sup")
```

When your listening process gets the message it will print out

```
"Hey I got a message: sup"
```

By default all listens and notifies happen on the same channel. If you want you can specify a different channel

```ruby
HeyYou.new(channel: "new_channel_name").listen do |payload|
  puts "Hey I got a message: #{payload}"
end
```

It is important to note that you need to notify against the same name.

```
HeyYou.new(channel: "new_channel_name").notify("sup")
```

By default the background thread wakes up every 60 seconds and waits 0.1 seconds to see if there is a message. You can customize this behavior using `sleep` and `ttl`. So to have it check every 10 seconds, and not wait at all you could run

```
HeyYou.new(ttl: 1, sleep: 10).listen do |payload|
  puts "Hey I got a message: #{payload}"
end
```

A lower sleep will decrease delay between sending and receiving messages but will decrease overall program performance.

## Connection

By default HeyYou assumes you're using Active Record and already have a connection configured. If you want to use a different ORM, you'll need to provide HeyYou with an object that responds to `exec` that executes arbitrary SQL and a method `wait_for_notify` that accepts `ttl`, `sleep` and takes a block.

You can configure your connection manually

```ruby
HeyYou.new(connection: my_custom_object)
```

Or you can set it globally

```ruby
HeyYou::DEFAULT_CONNECTION = my_custom_object
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hey_you. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


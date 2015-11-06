require "hey_you/version"

class HeyYou
  DEFAULT_CHANNEL = "hey_you_default_channel"
  DEFAULT_CONNECTION_CONNECTOR = Proc.new do
    if defined?(DEFAULT_CONNECTION)
      DEFAULT_CONNECTION
    elsif defined?(ActiveRecord::Base)
      ActiveRecord::Base.connection.raw_connection
    else
      false
    end
  end

  attr_reader :channel
  def initialize(ttl: 0.1, sleep: 60, channel: DEFAULT_CHANNEL, connection: DEFAULT_CONNECTION_CONNECTOR.call)
    raise "The new method does not take a block, perhaps you meant to call the listen method?" if block_given?
    @ttl     = ttl
    @sleep   = sleep
    @channel = channel
    @raw_connection = connection
  end

  def listen(&block)
    raise "No block given" unless block
    @raw_connection.exec "LISTEN #{channel}"

    @thread = Thread.new do
      while true do
        sleep @sleep

        @raw_connection.wait_for_notify(@ttl) do |channel_sent, pid, payload|
          block.call(payload) if channel_sent == self.channel
        end
      end
    end
  end
  alias :watch :listen

  def notify(payload)
    message = "NOTIFY #{channel}, '#{payload}'"
    puts message
    @raw_connection.exec(message)
  end
end

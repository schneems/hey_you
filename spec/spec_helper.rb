$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hey_you'
require 'fixtures/fixture_helper'

def new_log_file
  Pathname.new(Tempfile.new(["hey_you", ".log"]))
end

def fixture_path(name = nil)
  path = Pathname.new(File.expand_path("../fixtures", __FILE__))
  path = path.join(name) if name
  path
end

def expect_log_has_count(log:, count:, msg: "Got payload:")
  contents = File.read(log)
  actual   = contents.scan(msg).count
  expect(actual).to eq(count), "Expected #{msg.inspect} to occur #{count} times but was #{ actual.inspect } in:\n#{ contents.inspect }"
end

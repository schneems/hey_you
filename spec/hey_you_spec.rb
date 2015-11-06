require 'spec_helper'

describe HeyYou do
  it 'has a version number' do
    expect(HeyYou::VERSION).not_to be nil
  end

  it "only gets messages for specified channel" do
    begin
      log = new_log_file
      pid = Process.spawn("bundle exec ruby #{ fixture_path("twice.rb") } >> #{log}")
      sleep 4 # wait for listen to happen before we can notify
      HeyYou.new(channel: testing_key("twice_1")).notify("yoyoyo")
      HeyYou.new(channel: testing_key("twice_2")).notify("supsupsup")
      Process.wait(pid)

      expect_log_has_count(log: log, count: 1, msg: "yoyoyo")
      expect_log_has_count(log: log, count: 1, msg: "supsupsup")
    ensure
      FileUtils.remove_entry_secure log
    end
  end

  it "sends different processes messages" do
    begin
      log = new_log_file
      pid = Process.spawn("bundle exec ruby #{ fixture_path("once.rb") } >> #{log}")
      sleep 4 # wait for listen to happen before we can notify
      HeyYou.new(channel: testing_key("once")).notify("yoyoyo")
      Process.wait(pid)

      expect_log_has_count(log: log, count: 1, msg: "yoyoyo")
    ensure
      FileUtils.remove_entry_secure log
    end
  end
end

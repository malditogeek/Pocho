#!/usr/bin/env ruby

require 'yaml'
require File.dirname(File.expand_path(__FILE__)) + '/pocho_xmpp'

begin
  YAML.load_file('config.yml')
rescue Errno::ENOENT
  puts 'No config.yml file found, which is needed to run this script. You can copy config.yml.example as a starting point.'
  Process.exit
end

bot = PochoTheRobot.new config[:user], config[:password], config[:rooms]
bot.connect!

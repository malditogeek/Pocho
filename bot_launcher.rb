#!/usr/bin/env ruby

require 'yaml'
require File.expand_path('../pocho_xmpp', __FILE__)

begin
  config = YAML.load_file(File.expand_path('../config.yml',__FILE__))

rescue Errno::ENOENT
  puts 'No config.yml file found, which is needed to run this script. You can copy config.yml.example as a starting point.'
  Process.exit
end

bot = PochoTheRobot.new config[:user], config[:password], config[:rooms]
bot.connect!

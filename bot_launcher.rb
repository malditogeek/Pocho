#!/usr/bin/env ruby

require 'yaml'
require File.dirname(File.expand_path(__FILE__)) + '/pocho_xmpp'
config = YAML.load_file('config.yml')
bot = PochoTheRobot.new config[:user], config[:password], config[:rooms]
bot.connect!

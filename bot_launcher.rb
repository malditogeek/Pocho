#!/usr/bin/env ruby

require File.dirname(File.expand_path(__FILE__)) + '/pocho_xmpp'
bot = PochoTheRobot.new 'pocho@xmpp.example.com', 's3cr3t!', ['room@conference.xmpp.example.com']
bot.connect!

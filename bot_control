#!/usr/bin/env ruby

# Bundler
require File.expand_path('../.bundle/environment', __FILE__)

require 'daemons'

pwd = File.dirname(File.expand_path(__FILE__)) 
bot = pwd + '/bot_launcher.rb'

Daemons.run(bot, :dir_mode => :normal,
                 :dir => File.join(pwd, 'tmp'),
                 :backtrace => true,
                 :monitor => true,
                 :log_output => true)

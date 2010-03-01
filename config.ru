#!/usr/bin/env ruby

# Start with
# rackup -p 3001 config.ru

# Bundler
require ::File.expand_path('../.bundle/environment', __FILE__)

require 'sinatra'

set :environment, :production

disable :run, :reload

log = File.new("log/pocho_web.log", "a+") 
$stdout.reopen(log)
$stderr.reopen(log)

require 'pocho_web'
run Sinatra::Application

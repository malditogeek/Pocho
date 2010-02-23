#!/usr/bin/env ruby

# Start with
# rackup -p 3001 config.ru

# Bundler
require ::File.expand_path('../.bundle/environment', __FILE__)

require 'sinatra'

set :public,   ::File.expand_path('../public', __FILE__)
set :views,    ::File.expand_path('../views', __FILE__)
set :environment, :production

disable :run, :reload

log = ::File.new("log/pocho_web.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'pocho_web'
run Sinatra::Application

#!/usr/bin/env ruby

# Bundler
require File.expand_path('../.bundle/environment', __FILE__)

require 'sinatra'

set :public,   File.expand_path(File.dirname(__FILE__) + '/public')
set :views,    File.expand_path(File.dirname(__FILE__) + '/views') 
set :environment, :production

disable :run, :reload

log = File.new("log/pocho_web.log", "a+") 
STDOUT.reopen(log)
STDERR.reopen(log)

require 'pocho_web'
run Sinatra::Application

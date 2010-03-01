#!/usr/bin/env ruby

# Bundler
require File.expand_path('../.bundle/environment', __FILE__)

require 'sinatra'

set :environment, :production

disable :run, :reload

log = File.new("log/pocho_web.log", "a+") 
$stdout.reopen(log)
$stderr.reopen(log)

require 'pocho_web'
run Sinatra::Application

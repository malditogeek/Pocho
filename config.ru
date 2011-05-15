#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require

require 'sinatra'

set :environment, :production

disable :run, :reload

log = File.new("log/pocho_web.log", "a+") 
$stdout.reopen(log)
$stderr.reopen(log)

require 'pocho_web'
run Sinatra::Application

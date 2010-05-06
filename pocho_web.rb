#!/usr/bin/env ruby
require 'yaml'
begin
  config = YAML.load_file('config.yml')
rescue Errno::ENOENT
  puts 'No config.yml file found, which is needed to run this script. You can copy config.yml.example as a starting point.'
  Process.exit
end

# Bundler
require File.expand_path('../.bundle/environment', __FILE__)
require 'rubygems'
require 'sinatra'
require 'erb'
require 'active_support'

include ERB::Util

# Redis is the default datastore, but you can implement your own! 
# Take a look at 'pocho/datastores/dummy' to get started.
DATASTORE = :redis 
require "pocho/datastores/#{DATASTORE}"
require 'pocho/time'
require 'pocho/helpers'

set :public, File.expand_path(File.dirname(__FILE__) + '/public')
set :views , File.expand_path(File.dirname(__FILE__) + '/views') 

configure do
  DS = DataStore.new config[:user].split('@').last
end

# Sinatra songs

# Today messages
get '/' do
  @title    = "What's up?"
  @messages = DS.find_today_messages
  @tags     = DS.find_all_tags.map(&:downcase).sort
  erb :index
end

# Messages by tag
get '/tags/:tag' do
  tag       = params[:tag]
  @title    = "##{tag}"
  @messages = DS.find_messages_by_tag tag
  erb :index
end

# Messages by user
get '/users/:user' do
  user      = params[:user]
  @title    = user.split(/_|\./).first.camelize
  @messages = DS.find_messages_by_user user
  erb :index
end

# Messages by date
get '/:year/:month/:day' do
  y, m, d = params[:year], params[:month], params[:day]
  @title    = "#{y}/#{m}/#{d}"
  @messages = DS.find_messages_by_date y,m,d
  erb :index
end


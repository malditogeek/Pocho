#!/usr/bin/env ruby

# Bundler
require File.expand_path('../.bundle/environment', __FILE__)

require 'rubygems'
require 'sinatra'
require 'redis'
require 'erb'
require 'active_support'
require 'pocho/time'

include ERB::Util

# Redis
set :redis, Redis.new         # Redis connection
set :ns, 'xmpp.example.com' # Redis namespace

# Helpers
helpers do
  def auto_link(text)
    t = html_escape(text)
    t.scan(/#\w+/).each do |tag|
      t = t.gsub tag, "<a href='/tags/#{tag.gsub('#','')}'>#{tag}</a>"
    end
    t = t.gsub /((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)/, %Q{<a href="\\1" target="_blank">\\1</a>}
    t
  end
end

def find_msgs key
  options.redis.list_range(key, 0, -1).map {|m| Marshal.load(m)}
end

def find_tags
  options.redis.set_members "#{options.ns}:tags"
end

# Sinatra songs
get '/' do
  @title = "What's up?"
  t = Time.now
  @messages = find_msgs "#{options.ns}:timeline:#{t.year}:#{t.month}:#{t.day}"
  @tags = find_tags
  erb :index
end

get '/:year/:month/:day' do
  y, m, d = params[:year], params[:month], params[:day]
  @title = "#{y}/#{m}/#{d}"
  @messages = find_msgs "#{options.ns}:timeline:#{y}:#{m}:#{d}"
  @tags = find_tags
  erb :index
end

get '/tags/:tag' do
  tag = params[:tag]
  @title = "##{tag}"
  @messages = find_msgs "#{options.ns}:tag:##{tag}"
  erb :index
end

get '/users/:user' do
  user = params[:user]
  @title = user.split('_').first.camelize
  @messages = find_msgs "#{options.ns}:#{user}"
  erb :index
end


#!/usr/bin/env ruby
require 'redis'
require 'xmpp4r'
require 'xmpp4r-simple'
require 'xmpp4r/muc/helper/simplemucclient'

# Time class extended
class Time
  def year ; strftime('%Y'); end
  def month; strftime('%m'); end
  def day  ; strftime('%d'); end
end

# Pocho The Robot
class PochoTheRobot
  attr_accessor :ns
  attr_reader   :logger

  def initialize jid, passwd, rooms=[]
    @logger = Logger.new(STDOUT)
    @logger.level = ENV['DEBUG'] ? Logger::DEBUG : Logger::INFO

    @redis = Redis.new
    @ns = jid.split('@').last # Redis namespace

    logger.info "[Pocho] Connecting #{jid}"
    @pocho = Jabber::Simple.new(jid, passwd)
    @rooms = rooms # MUC rooms
  end

  def connect!
    @rooms.each do |room|
      Thread.new do
        muc = Jabber::MUC::SimpleMUCClient.new(@pocho.client)
        muc.on_message do |time,nick,msg|
          m = parse_and_store nick, msg, Time.now unless time # Avoid msg history
          muc.say "#{nick}: gotcha ;)" if m
        end
        muc.join("#{room}/Pocho The Robot")
      end
      logger.info "[Pocho] Listening for messages at #{room}..."
    end
    Thread.stop
    jabber.client.close
  end

  private
  
  def parse_and_store nick, msg, time
    logger.debug "[Pocho] Processing: #{nick.inspect} - #{msg.inspect}"

    tags = msg.strip.scan(/#\w+/) 
    if tags.any?
      tuple = Marshal.dump([nick, msg])
      tags.each do |tag| 
        @redis.push_head "#{@ns}:tag:#{tag}", tuple
        @redis.set_add "#{@ns}:tags", tag
      end
      @redis.push_head "#{@ns}:timeline:#{time.year}:#{time.month}:#{time.day}", tuple
      @redis.push_head "#{@ns}:#{nick.downcase.gsub(' ','_')}", tuple

      return true
    end

    return false

    rescue Exception => e
      logger.error "[Pocho] Exception: #{e.message} | Processing: #{msg.inspect}"
      logger.error e.backtrace
  end
end

#p = PochoTheRobot.new 'pocho@nb-mpompilio.local', 'p0ch0', ['xmppfoo@conference.nb-mpompilio.local','xmppbar@conference.nb-mpompilio.local']
#p.connect!


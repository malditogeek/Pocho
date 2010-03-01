# Bundler
require File.expand_path('../.bundle/environment', __FILE__)
require 'xmpp4r'
require 'xmpp4r-simple'
require 'xmpp4r/muc/helper/simplemucclient'

# Redis is the default datastore, but you can implement your own! 
# Take a look at 'pocho/datastores/dummy' to get started.
DATASTORE = :redis 
require File.expand_path("../pocho/datastores/#{DATASTORE}", __FILE__)
require File.expand_path('../pocho/time', __FILE__)

# Pocho The Robot
class PochoTheRobot
  attr_accessor :ns

  # Intitialization and Jabber authentication.
  def initialize jid, passwd, rooms=[]
    @logger = Logger.new(File.expand_path("../log/pocho_xmpp.log", __FILE__))

    @logger.level = ENV['DEBUG'] ? Logger::DEBUG : Logger::INFO

    @ns = jid.split('@').last # Namespace
    @ds = DataStore.new @ns

    logger.info "[Pocho] Connecting #{jid}"
    @pocho = Jabber::Simple.new(jid, passwd)
    @rooms = rooms # MUC rooms
  end

  # Connect to all the rooms and wait for messages.
  def connect!
    @rooms.each do |room|
      Thread.new do
        muc = Jabber::MUC::SimpleMUCClient.new(@pocho.client)
        muc.on_message do |time,user,msg|
          m = parse_and_store(user, msg, Time.now) unless time # Avoid msg history
          #muc.say "#{user}: gotcha ;)" if m
        end
        muc.join("#{room}/Pocho The Robot")
      end
      logger.info "[Pocho] Listening for messages at #{room}..."
    end
    Thread.stop
    jabber.client.close
  end

  private

  # Parse the message looking for #hashtags, if there's any, it'll be stored.
  def parse_and_store user, msg, time
    logger.debug "[Pocho] Processing: #{user.inspect} - #{msg.inspect}"

    msg = msg.strip
    tags = msg.scan(/ #[\w-]+/).map(&:strip)
    if tags.any?
      tuple = Marshal.dump([user, msg, time])
      tags.each do |tag|
        @ds.store_message_by_tag tuple, tag
        @ds.store_tag tag
      end
      @ds.store_message_by_date tuple, time
      @ds.store_message_by_user tuple, user
      return true
    else
      return false
    end

    rescue Exception => e
      logger.error "[Pocho] Exception: #{e.message} | Processing: #{msg.inspect}"
      logger.error e.backtrace
  end

  # Logger sugar.
  def logger
    @logger
  end
end

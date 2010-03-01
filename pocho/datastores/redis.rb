require 'redis'

class DataStore
  attr_reader :ns

  def initialize namespace, options={}
    @redis = Redis.new options
    @ns = namespace
  end

  # FIND
  def find_all_tags
    get_set "#{@ns}:tags"
  end
  def find_today_messages
    t = Time.now
    get_list "#{@ns}:timeline:#{t.year}:#{t.month}:#{t.day}"
  end
  def find_messages_by_date y,m,d
    get_list "#{@ns}:timeline:#{y}:#{m}:#{d}"
  end
  def find_messages_by_tag tag
    tag = tag.downcase
    get_list "#{@ns}:tag:##{tag}"
  end
  def find_messages_by_user user
    get_list "#{@ns}:#{user}"
  end

  # STORE
  def store_message_by_tag tuple, tag
    tag = tag.downcase
    @redis.push_head "#{@ns}:tag:#{tag}", tuple
  end
  def store_tag tag
    @redis.set_add "#{@ns}:tags", tag
  end
  def store_message_by_date tuple, time
    @redis.push_head "#{@ns}:timeline:#{time.year}:#{time.month}:#{time.day}", tuple
  end
  def store_message_by_user tuple, user
    user = user.downcase.gsub(' ','_')
    @redis.push_head "#{@ns}:#{user}", tuple
  end

  private
  def get_list key
    @redis.list_range(key, 0, -1).map {|m| Marshal.load(m)}
  end
  def get_set key 
    @redis.set_members key
  end
end



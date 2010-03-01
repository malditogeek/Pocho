class DataStore
  attr_reader :ns
  def initialize namespace, options={}
    @ns = namespace
  end

  # FIND
  def find_all_tags
    ['#omg','#bbq']
  end
  def find_today_messages
    [['dummy','dummy message #omg #bbq', Time.now]]
  end
  def find_messages_by_date y,m,d
    [['dummy','dummy message #omg #bbq', Time.now]]
  end
  def find_messages_by_tag tag
    [['dummy','dummy message #omg #bbq', Time.now]]
  end
  def find_messages_by_user user
    [['dummy','dummy message #omg #bbq', Time.now]]
  end

  # STORE
  def store_message_by_tag tuple, tag
    return true
  end
  def store_tag tag
    return true
  end
  def store_message_by_date tuple, time
    return true
  end
  def store_message_by_user tuple, user
    return true
  end

end


# Helpers
helpers do
  def auto_link text
    t = html_escape(text)
    t.scan(/#[\w-]+/).each do |tag|
      t = t.gsub tag, "<a href=\"/tags/#{tag.gsub('#','')}\">#{tag}</a>"
    end
    t = t.gsub /((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.-]*(\?\S+)?)?)?)/, %Q{<a href="\\1" target="_blank">\\1</a>}
    t
  end
  def sanitize text
    text.downcase.gsub(/\W/,'_') 
  end
  def logger
    LOGGER
  end
end

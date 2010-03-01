# Bundler
require File.expand_path('../../.bundle/environment', __FILE__)
Bundler.require :default, :test

require 'pocho_web'
require 'ruby-debug'

set :environment, :test

class PochoWebTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_empty_whats_up_page
    get '/'
    assert last_response.ok?

    doc = Nokogiri::HTML(last_response.body)
    assert doc.xpath('//div[@class="message"]').text.strip == 'hmmm... nothing yet'
  end

  def test_whats_up_page
    DS.stubs(:find_all_tags).returns(['#omg','#wtf','#bbq']).once
    DS.stubs(:find_today_messages).returns([['Pocho The Robot', 'Eats #bbq']]).once

    get '/'
    assert last_response.ok?
    doc = Nokogiri::HTML(last_response.body)

    # Tags
    assert doc.xpath('//div[@id="tags"]/div[@class="tag"]').length == 3 
    assert doc.xpath('//div[@id="tags"]/div[@class="tag"]/a').first.attr('href') == '/tags/omg'

    # Messages 
    assert doc.xpath('//div[@class="message"]/p').text.strip == 'Pocho The Robot: Eats #bbq'
    assert doc.xpath('//div[@class="message"]/p/a[@class="nick"]').attr('href').value == '/users/pocho_the_robot'
  end

  def test_messages_by_tag
    DS.stubs(:find_messages_by_tag).with('bbq').returns([['Pocho The Robot', 'Eats #bbq']]).once

    get '/tags/bbq'
    assert last_response.ok?
    doc = Nokogiri::HTML(last_response.body)

    # Title
    assert doc.xpath('//h1').text == '#bbq'

    # Messages 
    assert doc.xpath('//div[@class="message"]/p').text.strip == 'Pocho The Robot: Eats #bbq'
    assert doc.xpath('//div[@class="message"]/p/a[@class="nick"]').attr('href').value == '/users/pocho_the_robot'
  end

  def test_messages_by_user
    DS.stubs(:find_messages_by_user).with('pocho_the_robot').returns([['Pocho The Robot', 'Eats #bbq']]).once

    get '/users/pocho_the_robot'
    assert last_response.ok?
    doc = Nokogiri::HTML(last_response.body)

    # Title
    assert doc.xpath('//h1').text == 'Pocho'

    # Messages 
    assert doc.xpath('//div[@class="message"]/p').text.strip == 'Pocho The Robot: Eats #bbq'
    assert doc.xpath('//div[@class="message"]/p/a[@class="nick"]').attr('href').value == '/users/pocho_the_robot'
  end

  def test_messages_by_date
    DS.stubs(:find_messages_by_date).with('2010','02','25').returns([['Pocho The Robot', 'Eats #bbq']]).once

    get '/2010/02/25'
    assert last_response.ok?
    doc = Nokogiri::HTML(last_response.body)

    # Title
    assert doc.xpath('//h1').text == '2010/02/25'

    # Messages 
    assert doc.xpath('//div[@class="message"]/p').text.strip == 'Pocho The Robot: Eats #bbq'
    assert doc.xpath('//div[@class="message"]/p/a[@class="nick"]').attr('href').value == '/users/pocho_the_robot'
  end

end

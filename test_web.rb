require 'rubygems'
gem 'rack'
require 'web'
require 'test/unit'
require 'rack/test'


class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include Sinatra::Twitto::Default::Helpers
  
  def app
    TwitTo
  end

  def test_tweet_helper
    result = compose_tweet("hello: ", "world", "http://www.google.com")
    assert_equal 'hello: world (http://www.google.com)', result

    result = compose_tweet("hello: ", "w"*140, "http://www.google.com")
    assert result =~ /^hello:/
    assert result =~ /http:\/\/www.google.com\)$/    
    assert_equal result.length, 140
  end
end
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
    assert_equal 140, result.length
  end

  # multibyte character is not handled properly by native ruby 1.8
  # use active_support library should solve this
  def test_multibyte
    result = compose_tweet("Laughing: ", "&quot;绿坝绿坝★河蟹你全家feveR.【词：荼荼丸 歌：方正畅听软件音源】 - AcFun.cn&quot; 原來還有國產版 NICO？！", "http://bit.ly/Lt6Ag")
    assert result =~ /^Laughing:/
    assert result =~ /http:\/\/bit.ly\/Lt6Ag\)$/
    assert result =~ /原來還有國產版/, "#{result}"
    assert result.mb_chars.length <= 140
  end
end
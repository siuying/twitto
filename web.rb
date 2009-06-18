#!/usr/bin/env ruby
require 'rubygems'
require 'json'

require 'sinatra/base'
require 'lib/sinatra/oauth_auth'
require 'lib/sinatra/twitter'
require 'lib/sinatra/bitly'
require 'lib/twitto/default'

class TwitTo < Sinatra::Default
  register Sinatra::BitlyClient
  register Sinatra::OauthAuth
  register Sinatra::TwitterClient
  register Sinatra::Twitto::Default
  
  enable :sessions
end
#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'sinatra/base'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{FileUtils.pwd}/twitto.db")
DataMapper.auto_migrate!
require 'lib/sinatra/twitto'

class TwitTo < Sinatra::Default
  register Sinatra::BitlyClient
  register Sinatra::OauthAuth
  register Sinatra::TwitterClient
  register Sinatra::Twitto::Default
#  register Sinatra::Twitto::Customize

  set :views,  'views'
  set :public, 'public'
  set :environment, :production

  enable :sessions
end

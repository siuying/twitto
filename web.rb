#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'sinatra/base'
require 'lib/sinatra/twitto'


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{FileUtils.pwd}/twitto.db")
User.first rescue DataMapper.auto_migrate!

class TwitTo < Sinatra::Default
  register Sinatra::BitlyClient
  register Sinatra::OauthAuth
  register Sinatra::TwitterClient
  register Sinatra::Twitto::Default
  register Sinatra::Twitto::Customize

  set :views,  'views'
  set :public, 'public'
  set :environment, :production

  enable :sessions
end

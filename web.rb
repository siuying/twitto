#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'sinatra/base'

gem 'datamapper', '>= 0.9.11'
gem 'data_objects', '>= 0.9.11'
require 'data_objects'
gem 'do_postgres', '>= 0.9.11'
require 'do_postgres'
require 'datamapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{FileUtils.pwd}/twitto.db")
DataMapper.auto_migrate!
require 'lib/sinatra/twitto'

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

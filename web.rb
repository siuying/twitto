#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'json'

require 'lib/sinatra/oauth_auth'
require 'lib/sinatra/twitter'
require 'lib/sinatra/bitly'

@@config = YAML.load_file("config.yml") rescue nil || {}

configure do
  set :sessions, true
  set :app_file, __FILE__
  set :reload, true
end

get '/' do
  erb :index
end

# Allow user to input tweet
get '/go' do
  authorize!("/go?title=#{u params[:title]}&url=#{u params[:url]}")
  @title      = params[:title] || ""
  @url        = params[:url]   || ""
  @short_url  = bitly.shorten(@url).short_url rescue @url
  @actions    = JSON(@@config['actions']) 
  erb :go
end

# Accept user input and post them to Twitter
post '/go' do
  authorize!
  @url     = params[:url]     || ""
  @message = params[:message] || ""
  @action  = params[:action]  || ""

  tweet = "#{@action} #{@message} (#{@url})"
  twitter.update(tweet)
  erb :close
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text) 
  end
  def u(text)
    Rack::Utils.escape(text) 
  end
end
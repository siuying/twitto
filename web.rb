#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'lib/sinatra/oauth_auth'
require 'lib/sinatra/twitter'
require 'lib/sinatra/bitly'

configure do
  set :sessions, true
  set :app_file, __FILE__
  set :reload, true
end

get '/' do
  redirect '/go' if authorized?
  erb :index
end

get '/go' do
  authorize!
  @title      = params[:title] || ""
  @url        = params[:url]   || ""
  @short_url  = bitly.shorten(@url).short_url
  erb :go
end

post '/go' do
  authorize!
  url     = params[:url] || ""
  message = params[:message] || ""
  twitter.update("Reading: #{message} (#{url})")
  erb :close
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text) 
  end
end
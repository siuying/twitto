#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

require 'lib/sinatra/oauth_auth'
require 'lib/sinatra/twitter'

configure do
  set :sessions, true
end

get '/' do
  redirect '/new' if authorized?
  erb :index
end

get '/new' do
  authorize!
  twitter!
  "twitter timeline: #{@twitter.user_timeline.collect(){|m| m.text}}"
end

helpers do
  def partial(name, options={})
    erb("_#{name.to_s}".to_sym, options.merge(:layout => false))
  end
end
#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'cgi'
require 'oauth'

configure do
  set :sessions, true
  @@config = YAML.load_file("config.yml") rescue nil || {}
end
 
before do
  @user = session[:user]
  @oauth = OAuth::Consumer.new(
    @@config['consumer_key'],
    @@config['consumer_secret'],
    {:site => @@config['site']}
  )
  @oauth_callback = @@config['callback']
end
 
get '/' do
  redirect '/new' if @user
  erb :index
end

# Post Link
get '/new' do
  redirect '/connect' unless @user
  erb :new
end

# store the request tokens and send to oauth
get '/connect' do
  request_token = @oauth.get_request_token(:oauth_callback => @oauth_callback)
  session[:request_token] = request_token.token
  session[:request_token_secret] = request_token.secret
  redirect request_token.authorize_url
end
 
# auth URL is called by twitter after the user has accepted the application
# this is configured on the Twitter application settings page
get '/auth' do
  # Exchange the request token for an access token.
  @request_token = OAuth::RequestToken.new(@oauth,
    session[:request_token],
    session[:request_token_secret])
    
  begin
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

    # Storing the access tokens so we don't have to go back to Twitter again
    # in this session. In a larger app you would probably persist these details somewhere.
    session[:access_token] = @access_token.token
    session[:secret_token] = @access_token.secret
    session[:user] = true
    if session[:redirect_to]
      url = session[:redirect_to]
      session[:redirect_to] = nil              
      redirect url
    else
      redirect '/new'
    end    
  rescue OAuth::Unauthorized => e
    redirect '/'
  end
end
 
get '/logout' do
  session[:user] = nil
  session[:request_token] = nil
  session[:request_token_secret] = nil
  session[:access_token] = nil
  session[:secret_token] = nil
  redirect '/'
end
 
helpers do
  def partial(name, options={})
    erb("_#{name.to_s}".to_sym, options.merge(:layout => false))
  end
end
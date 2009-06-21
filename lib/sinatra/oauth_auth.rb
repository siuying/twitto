require 'sinatra/base'
require 'oauth'
require 'logger'

# OauthAuth Module
module Sinatra
  module OauthAuth
    module Helpers

      def authorized?
        session[:authorized]
      end

      def authorize!(target=nil)
        unless authorized?
          begin
            @log.debug "user not authorized, redirect user [#{target}]"
            session[:redirect_to] = target
            request_token = @oauth.get_request_token(:oauth_callback => options.oauth_callback)
            session[:request_token] = request_token.token
            session[:request_token_secret] = request_token.secret
            redirect request_token.authorize_url

          rescue OAuth::Unauthorized => e
            @log.error "Failed to attain oauth request token. OAuth not authorize with our auth key? [oath_key=#{options.oauth_key}, error=#{e.inspect}]"
            raise "Error acquiring OAuth token, cannot authenticate ourself with oauth server!"
          end

        end
      end

      def logout!
        @log.debug "logout user #{session[:user]}"
        session[:authorized]    = false
        session[:user_id]       = nil
        session[:screen_name]   = nil
        session[:request_token] = nil
        session[:request_token_secret] = nil
        session[:access_token]  = nil
        session[:secret_token]  = nil
      end
    end

    def self.registered(app)
      app.helpers OauthAuth::Helpers
      app.set :oauth_site,      "http://twitter.com"

      # Override these, or supply ENV variables
      app.set :oauth_key,       ENV['OAUTH_KEY']
      app.set :oauth_secret,    ENV['OAUTH_SECRET']
      app.set :oauth_callback,  "#{ENV['SERVER_HOST']}/auth"

      app.before do
        @log ||= $LOGGER || Logger.new(STDOUT)              
        @oauth = OAuth::Consumer.new(
          options.oauth_key,
          options.oauth_secret,
          {:site => options.oauth_site}
        )
      end
      
      app.get '/login' do
        authorize!
      end

      app.get '/logout' do
        logout!
        redirect '/'
      end
      
      # handle authentication
      # raise OAuth::Unauthorized
      app.get '/auth' do
        # Exchange the request token for an access token.
        @request_token = OAuth::RequestToken.new(@oauth,
          session[:request_token], 
          session[:request_token_secret])

        @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
        session[:access_token]  = @access_token.token
        session[:secret_token]  = @access_token.secret
        session[:user_id]       = @access_token.params["user_id"]     rescue ""
        session[:screen_name]   = @access_token.params["screen_name"] rescue ""
        session[:authorized]    = true
        @log.info "authorized, user [#{session[:user_id]}]"
        
        if session[:redirect_to]
          url = session[:redirect_to]
          session[:redirect_to] = nil              
          redirect url
        else
          redirect '/'
        end
      end
    end
  end

  register OauthAuth
  
end

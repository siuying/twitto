require 'sinatra/base'
require 'oauth'
require 'logger'

module Sinatra
  module OauthAuth
    module Helpers
      @@config = YAML.load_file("config.yml") rescue nil || {}

      def init_oauth
        @log              = $LOGGER || Logger.new(STDOUT)
        @oauth_key        = ENV['OAUTH_KEY']
        @oauth_secret     = ENV['OAUTH_SECRET']
        @oauth_callback   = "#{ENV['SERVER_HOST']}/auth"
                
        @oauth = OAuth::Consumer.new(
          @oauth_key,
          @oauth_secret,
          {:site => @@config['site']}
        )
      end
      
      def authorized?
        session[:authorized]
      end

      def authorize!(target=nil)
        unless authorized?
          @log.debug "user not authorized, redirect user [#{target}]"
          session[:redirect_to] = target
          request_token = @oauth.get_request_token(:oauth_callback => @oauth_callback)
          session[:request_token] = request_token.token
          session[:request_token_secret] = request_token.secret
          redirect request_token.authorize_url
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
      
      app.before do
        init_oauth
      end
      
      app.get '/connect' do
        authorize!
      end

      app.get '/logout' do
        logout!
        redirect '/'
      end
      
      # handle authentication
      # throw OAuth::Unauthorized
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

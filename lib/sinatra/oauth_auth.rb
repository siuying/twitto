require 'sinatra/base'
require 'oauth'
require 'logger'

module Sinatra
  module OauthAuth
    module Helpers
      @@config = YAML.load_file("config.yml") rescue nil || {}

      def init_oauth
        @oauth = OAuth::Consumer.new(
          ENV['OAUTH_KEY'],
          ENV['OAUTH_SECRET'],
          {:site => @@config['site']}
        )
        @oauth_callback = @@config['callback']
      end
      
      def authorized?
        session[:authorized]
      end

      def authorize!(target=nil)
        unless authorized?
          session[:redirect_to] = target
          request_token = @oauth.get_request_token(:oauth_callback => @oauth_callback)
          session[:request_token] = request_token.token
          session[:request_token_secret] = request_token.secret
          redirect request_token.authorize_url
        end
      end

      def logout!
        session[:user] = nil
        session[:request_token] = nil
        session[:request_token_secret] = nil
        session[:access_token] = nil
        session[:secret_token] = nil
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
      
      app.get '/auth' do
          # Exchange the request token for an access token.
          @request_token = OAuth::RequestToken.new(@oauth,
            session[:request_token], 
            session[:request_token_secret])

          begin
            @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
            session[:access_token] = @access_token.token
            session[:secret_token] = @access_token.secret
            session[:authorized] = true
            if session[:redirect_to]
              url = session[:redirect_to]
              session[:redirect_to] = nil              
              redirect url
            else
              redirect '/'
            end
          rescue OAuth::Unauthorized => e
            # log error here
            redirect '/'
          end
        end
    end
  end

  register OauthAuth
  
end

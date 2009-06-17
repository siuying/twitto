gem 'siuying-twitter'
require 'twitter'
require 'sinatra/base'

module Sinatra
  module TwitterClient
    module Helpers
      def twitter
        raise "Require OauthAuth!" unless session
        return @twitter if @twitter

        oauth = Twitter::OAuth.new(ENV['OAUTH_KEY'], ENV['OAUTH_SECRET'])
        oauth.authorize_from_access(session[:access_token] , session[:secret_token])
        @twitter = Twitter::Base.new(oauth)
      end
    end
    def self.registered(app)
      helpers TwitterClient::Helpers
    end
  end

  register TwitterClient
end

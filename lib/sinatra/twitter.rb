gem 'siuying-twitter'
require 'twitter'
require 'sinatra/base'

module Sinatra
  module TwitterClient
    module Helpers
      @@config = YAML.load_file("config.yml") rescue nil || {}

      def twitter
        raise "Require OauthAuth!" unless session
        return @twitter if @twitter

        oauth = Twitter::OAuth.new(@@config['consumer_key'], @@config['consumer_secret'])
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

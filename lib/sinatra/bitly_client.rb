gem 'philnash-bitly'
require 'bitly'
require 'sinatra/base'

# Bitly URL Shortener Client Module
module Sinatra
  module BitlyClient
    module Helpers
      def bitly
        @bitly ||= Bitly.new(options.bitly_user, options.bitly_key)
      end
    end
    def self.registered(app)
      app.helpers BitlyClient::Helpers
      
      # Override these, or supply ENV variables
      app.set :bitly_user, ENV['BITLY_USER']
      app.set :bitly_key,  ENV['BITLY_KEY']
    end
  end

  register BitlyClient
end

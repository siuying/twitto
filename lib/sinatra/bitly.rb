gem 'philnash-bitly'
require 'bitly'
require 'sinatra/base'

module Sinatra
  module BitlyClient
    module Helpers
      def bitly
        @bitly ||= Bitly.new(ENV['BITLY_USER'],  ENV['BITLY_KEY'])
      end
    end
    def self.registered(app)
      app.helpers BitlyClient::Helpers
    end
  end

  register BitlyClient
end

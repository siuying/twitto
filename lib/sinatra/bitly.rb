gem 'philnash-bitly'
require 'bitly'
require 'sinatra/base'

module Sinatra
  module BitlyClient
    module Helpers
      @@config = YAML.load_file("config.yml") rescue nil || {}

      def bitly
        @bitly ||= Bitly.new(@@config['bitly_user'],  @@config['bitly_key'])
      end
    end
    def self.registered(app)
      helpers BitlyClient::Helpers
    end
  end

  register BitlyClient
end

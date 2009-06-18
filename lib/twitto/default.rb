require 'sinatra/base'

module Sinatra
  module Twitto
    # Default Twitto module, requires BitlyClient, OAuthAuth and TwitterClient
    module Default
      @@config = YAML.load_file("config.yml") rescue nil || {}

      def self.registered(app)
        app.helpers Helpers
        
        app.get '/' do
          erb :index
        end
        
        # Allow user to input tweet
        app.get '/go' do
          authorize!("/go?title=#{u params[:title]}&url=#{u params[:url]}")
          @title      = params[:title] || ""
          @url        = params[:url]   || ""
          @short_url  = bitly.shorten(@url).short_url rescue @url
          @actions    = JSON(@@config['actions']) 
          erb :go
        end
        
        # Accept user input and post them to Twitter
        app.post '/go' do
          authorize!
          url     = params[:url]     || ""
          message = params[:message] || ""
          action  = params[:action]  || ""

          tweet = compose_tweet(action, message, url)
          twitter.update(tweet)
          erb :close
        end

        app.error OAuth::Unauthorized do
          erb :rejected
        end
        
        app.error do
          "Opps! Something happened. Please report to me @siuying"
        end
      end
      
      module Helpers
        def compose_tweet(action, message, url)
          remaining = 140 - url.length - action.length - 3
          "#{action}#{message[0,remaining]} (#{url})"
        end
        def h(text)
          Rack::Utils.escape_html(text) 
        end
        def u(text)
          Rack::Utils.escape(text)                      
        end
      end
    end
  end

  register Twitto::Default
end

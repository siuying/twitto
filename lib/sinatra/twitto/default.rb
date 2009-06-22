require 'sinatra/base'
$KCODE = 'UTF8'

gem 'activesupport', '>= 2.2.0'
require 'active_support'

module Sinatra
  module Twitto
    # Default Twitto module, requires BitlyClient, OAuthAuth and TwitterClient
    module Default
      @@config = YAML.load_file("config.yml") rescue nil || {}

      def self.registered(app)
        app.helpers Helpers

        app.before do
          @log ||= $LOGGER || Logger.new(STDOUT)              
          @default_options = @@config['actions']
        end
        
        app.get '/' do
          erb :index
        end
        
        # Allow user to input tweet
        app.get '/go' do
          authorize! "/go?title=#{u params[:title]}&url=#{u params[:url]}"
          
          @user       = find_or_create_user(session[:screen_name])
          @title      = params[:title] || ""
          @url        = params[:url]   || ""
          @short_url  = bitly.shorten(@url).short_url rescue @url
          @actions    = @user.actions.collect(){|a| [a.id, a.name, a.fav?]}.to_json
          @fav_action = Action.first(:fav => true, :user_id => @user.id).name.to_json

          erb :go
        end
        
        # Accept user input and post them to Twitter
        app.post '/go' do
          authorize!

          url     = params[:url]     || ""
          message = params[:message] || ""
          action  = params[:action]  || ""

          tweet = compose_tweet(action, message, url)

          @log.info "#{session[:screen_name]} Tweeted: #{tweet}"
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
          "#{action}#{message.mb_chars.slice(0..(remaining-1))} (#{url})"
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

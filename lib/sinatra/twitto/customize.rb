require 'sinatra/base'
$KCODE = 'UTF8'

gem 'activesupport', '>= 2.2.0'
require 'active_support'

module Sinatra
  module Twitto
    # Default Customize module, allow user to customize the app
    module Customize
      @@config = YAML.load_file("config.yml") rescue nil || {}

      def self.registered(app)
        app.helpers Helpers
        
        app.before do
          @log ||= $LOGGER || Logger.new(STDOUT)              
          @default_options = @@config['actions']
        end

        app.get '/customize' do
          authorize!
          @user = find_or_create_user(session[:screen_name])

          erb :custom
        end
        
        app.post '/customize' do
          authorize!
          @user = find_or_create_user(session[:screen_name])
          
          session[:redirect_to] = request.referer 
          @back_url = session[:redirect_to]

          erb :custom
        end
        
        # fave a action for a user
        # set that action to fave, all others as non-fave
        # 
        # user must logged in
        #
        # params: 
        #   callback - the jsonp callback
        #   aid - the action id
        app.post '/fave' do
          authorize!
          aid       = params['aid']

          begin
            @user = find_or_create_user(session[:screen_name])
            @action = Action.get(aid)
            @user.fav(@action)
            @user.save
            "{'status': 'ok'}"
          rescue StandardError => e
            "{'error' : '#{Rack::Utils.escape_html e.message}'}"
          end
        end
        
        # reset current user actions to default value
        #
        # user must logged in
        app.post '/reset' do
          authorize!

          begin
            @user = find_or_create_user(session[:screen_name])
            User.transaction do |txn|
              reset_user(@user)
              @user.save
            end
            "{'status': 'ok'}"
          rescue StandardError => e
            "{'error' : '#{Rack::Utils.escape_html e.message}'}"
          end
        end
        
        app.post '/action.add' do
          authorize!
          name      = params['name']
          
          begin
            @user = find_or_create_user(session[:screen_name])
            action = Action.first(:name => name) || Action.new(:name => name, :user => @user)
            action.save
            "{'status': 'ok'}"
          rescue StandardError => e
            "{'error' : '#{Rack::Utils.escape_html e.message}'}"
          end
        end

        app.post '/action.del' do
          authorize!
          name      = params['name']

          begin
            @user = find_or_create_user(session[:screen_name])
            @action = Action.first(:name => name, :user => @user)
            @action.delete

            "{'status': 'ok'}"
          rescue StandardError => e
            "{'error' : '#{Rack::Utils.escape_html e.message}'}"
          end
        end
      end
      
      module Helpers
        include DataMapper::Model::Transaction
        def find_or_create_user(user_id)
          raise "cannot find user" if user_id.nil?
          user = User.first(:name => user_id) || User.new(:name => user_id)
          User.transaction do |txn|
            reset_user(user) if user.new_record?
            user.save
          end
          user
        end
        
        def reset_user(user)
          raise "user cannot be nil" if user.nil?
          user.actions.destroy!
          @default_options.each do |option|
            user.actions << Action.new(:name => option)              
          end

          first_action = user.actions.first
          first_action.fav = true
          first_action.save
        end
        
      end

    end
  end

  register Twitto::Default
end

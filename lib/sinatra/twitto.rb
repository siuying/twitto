path = File.expand_path(File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)

require 'oauth_auth'
require 'twitter'
require 'bitly'

gem 'datamapper', '>= 0.9.11'
gem 'data_objects', '>= 0.9.11'
require 'data_objects'
gem 'do_postgres', '>= 0.9.11'
require 'do_postgres'
require 'datamapper'
require 'lib/sinatra/twitto'

module Sinatra
  module Twitto
    class User
      include DataMapper::Resource
      property  :id,         Serial
      property  :name,       String, :length => 256
      has n, :actions

      def fav(action)
        actions.each do |a|
          if a.id != action.id
            a.fav = false
          else
            a.fav = true
          end
        end
      end
    end
    
    class Action
      include DataMapper::Resource
      property  :id,     Serial
      property  :name,   String,  :length => 50
      property  :fav,    Boolean, :default => false
      belongs_to :user
    end
  end
end

require 'twitto/default'
require 'twitto/customize'
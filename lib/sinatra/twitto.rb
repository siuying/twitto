path = File.expand_path(File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)

require 'oauth_auth'
require 'twitter_client'
require 'bitly_client'

module Sinatra
  module Twitto
  end
end

gem 'datamapper', '>= 0.9.11'
gem 'data_objects', '>= 0.9.11'
require 'data_objects'
gem 'do_postgres', '>= 0.9.11'
require 'do_postgres'
require 'datamapper'
require 'lib/sinatra/twitto'

require 'twitto/action'
require 'twitto/user'
require 'twitto/default'
require 'twitto/customize'
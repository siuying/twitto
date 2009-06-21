path = File.expand_path(File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)

require 'oauth_auth'
require 'twitter'
require 'bitly'

module Sinatra
  module Twitto
  end
end

gem 'datamapper'
require 'datamapper'

require 'twitto/user'
require 'twitto/action'
require 'twitto/default'
require 'twitto/customize'
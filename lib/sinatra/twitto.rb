path = File.expand_path(File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)

require 'oauth_auth'
require 'twitter'
require 'bitly'

module Sinatra
  module Twitto
  end
end

require 'twitto/action'
require 'twitto/user'
require 'twitto/default'
require 'twitto/customize'
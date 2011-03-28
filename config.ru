require 'rubygems'
require 'bundler'

Bundler.require

require './app'

use Rack::Static, :urls => ["/css", "/images", "/js", "/favicon.ico"], :root => "public"

run Oliland

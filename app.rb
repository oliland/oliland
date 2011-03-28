require 'sinatra/base'
require 'erb'
require 'rdiscount'

class Oliland < Sinatra::Base

  get '/' do
    markdown :index, :layout_engine => :erb
  end

  get '/blog/:title/?' do
    markdown :"#{params[:title]}", :layout_engine => :erb
  end

  get '/skydiving/?' do
    erb :skydiving
  end

end

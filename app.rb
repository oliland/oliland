require 'sinatra/base'
require 'erb'
require 'rdiscount'

class Oliland < Sinatra::Base

  get '/' do
    @contents = true
    @projects = true
    markdown :index, :layout_engine => :erb
  end

  get '/basement/?' do
    markdown :"basement/index", :layout_engine => :erb
  end

  get '/blog/:title/?' do
    markdown :"blog/#{params[:title]}", :layout_engine => :erb
  end

end

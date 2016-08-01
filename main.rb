require 'sinatra/reloader'
require 'sinatra'
require 'active_record'
require 'pry'

require_relative 'db_config'
require_relative 'models/game'
require_relative 'models/user'

enable :sessions

helpers do

  def logged_in?
    if User.find_by(id: session[:id])
      return true
    else
      return false
    end
  end

  def current_user
    User.find(session[:id])
  end

end

get '/' do
  if !logged_in?
    redirect to '/login'
  end
  erb :login
  erb :index
end

get '/sign_up' do
  erb :sign_up
end

get '/forgot_password' do
  erb :forgot_password
end

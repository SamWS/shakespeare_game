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
    redirect '/session/new'
  end
  erb :index
end

get '/login' do
  erb :login
end

get '/sign_up' do
  erb :sign_up
end

get '/forgot_password' do
  erb :forgot_password
end

get '/games/new' do
  erb :new
end
################
post '/user' do
  user = User.new
  user.name = params[:name]
  user.email = params[:email]
  user.password = params[:password]
  user.admin = false
  user.save

  session[:id] = user.id

  redirect '/'
end

get '/user/:id' do
  @user = User.find(params[:id])

  erb :account_edit
end

put '/user/:id' do
  if !logged_in?
    redirect to '/session/new'
  end


  user = User.find(params[:id])
  user.name = params[:name]
  user.email = params[:email]
  user.password = params[:password]
  user.save

  redirect to '/'
end

delete '/user/:id' do
  user = User.destroy(params[:id])

  redirect to '/'
end

################
post '/games' do

  if !logged_in?
    redirect to '/session/new'
  end

  games = Game.new
  games.play = params[:play]
  games.quote = params[:quote]
  games.character = params[:character]
  games.save
  redirect to '/my_quotes'
end

get '/games/:id' do
  @game = Game.find(params[:id])

  erb :show
end

get '/games/:id/edit' do
  @game = Game.find(params[:id])

  erb :game_edit
end

put '/games/:id' do
  if !logged_in?
    redirect to '/session/new'
  end


  games = Game.find(params[:id])
  games.play = params[:play]
  games.quote = params[:quote]
  games.character = params[:character]
  games.save

  redirect to '/my_quotes'
  erb :my_quotes
end

delete '/games/:id' do
  games = Game.destroy(params[:id])

  redirect to '/'
end

get '/session/new' do
  erb :login
end

post '/session' do
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    session[:id] = user.id
    redirect to '/'
  else
    erb :login
  end
end

delete '/session' do
  session[:id] = nil
  redirect to '/session/new'
end

get '/my_quotes' do
  @games = Game.all

  erb :my_quotes
end

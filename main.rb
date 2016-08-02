require 'sinatra/reloader'
require 'sinatra'
require 'active_record'
require 'pry'

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/quote'
require_relative 'models/play'

enable :sessions


get '/' do
  @current_user = User.current_user(session)

  if !User.logged_in?(session)
    redirect to('/login')
  else
    erb :index
  end
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

get '/quotes/new' do
  @current_user = User.current_user(session)

  if @current_user.admin?
    erb :new_quote
  else
    erb :my_quotes
  end

end

get '/plays/new' do
  @current_user = User.current_user(session)

  if @current_user.admin?
    erb :new_play
  else
    erb :my_plays
  end

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
  @current_user = User.current_user(session)

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
post '/plays' do
  @current_user = User.current_user(session)

  if !User.logged_in?(session)
    redirect to '/session/new'
  end

  play = Play.new
  play.title = params[:title]
  play.save
  redirect to '/my_plays'
end

get '/plays/:id/edit' do
  @play = Play.find(params[:id])
  erb :plays_edit

end

delete '/plays/:id' do
  play = Play.destroy(params[:id])

  redirect to '/my_plays'
end

put '/plays/:id' do
  if !User.logged_in?(session)
    redirect to '/session/new'
  end

  play = Play.find(params[:id])
  play.title = params[:title]
  play.save

  redirect to '/my_plays'
  erb :my_plays
end

delete '/plays/:id' do
  play = Play.destroy(params[:id])

  redirect to '/my_plays'
end

###############

post '/quotes' do

  if !User.logged_in?(session)
    redirect to '/session/new'
  end

  quote = Quote.new
  quote.script = params[:script]
  quote.character = params[:character]
  quote.play_id = params[:play_id]
  quote.save
  redirect to '/my_quotes'
end

get '/quotes/:id/edit' do
  @quote = Quote.find(params[:id])

  erb :quotes_edit
end


put '/quotes/:id' do
  if !User.logged_in?(session)
    redirect to '/session/new'
  end


  quote = Quote.find(params[:id])
  quote.script = params[:script]
  quote.character = params[:character]
  quote.play_id = params[:play_id]
  quote.save

  redirect to '/my_quotes'
  erb :my_quotes
end


delete '/quotes/:id' do
  quote = Quote.destroy(params[:id])

  redirect to '/my_quotes'
end


#####################

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
  @quotes = Quote.all
  @current_user = User.current_user(session)

  erb :my_quotes
end

get '/my_plays' do
  @plays = Play.all
  @current_user = User.current_user(session)

  erb :my_plays
end

get '/play_game' do
  @quote = Quote.all.sample
  @play_title = Play.all.where(id: @quote.play_id)
  @randomPlays = (Play.all - Play.where(id: @quote.play_id)).shuffle.take(3)
  @unshuffled_list = @play_title + @randomPlays
  erb :play_game
end

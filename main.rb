require 'sinatra/reloader'
require 'sinatra'
require 'active_record'
require 'pry'

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/quote'
require_relative 'models/play'

enable :sessions

helpers do

  def logged_in?(session)
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

############################

get '/' do

  if !logged_in?(session)
    redirect to '/login'
  else
    @current_user = current_user
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
  @current_user = current_user

  if !@current_user.admin?
    redirect to '/'
  end

  erb :new_quote

end

get '/plays/new' do
  @current_user = current_user

  if !@current_user.admin?
    redirect to '/'
  end

  erb :new_play

end

###########################

post '/user' do
  user = User.new
  user.name = params[:name]
  user.email = params[:email]
  user.password = params[:password]
  user.admin = false
  user.current_score = 0
  user.high_score = 0
  user.save

  session[:id] = user.id

  redirect '/'
end

get '/user/:id' do

  @current_user = current_user

  if !logged_in?(session)
    redirect to '/session/new'
  end

  erb :account_edit
end

put '/user/:id' do

  @current_user = current_user

  if !logged_in?(session)
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

  @current_user = current_user

  if !logged_in?(session)
    redirect to '/session/new'
  end

  user = User.destroy(params[:id])

  redirect to '/'
end

###########################

post '/plays' do
  @current_user = current_user

  if !@current_user.admin?
    redirect to '/'
  end

  play = Play.new
  play.title = params[:title]
  play.save
  redirect to '/my_plays'
end

get '/plays/:id/edit' do
  @play = Play.find(params[:id])
  @current_user = current_user

  if !@current_user.admin?
    redirect to '/'
  end

  erb :plays_edit

end

put '/plays/:id' do
  @current_user = current_user

  if !@current_user.admin?
    redirect to '/'
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

##############################

post '/quotes' do
  @current_user = current_user

  if !@current_user.admin?
    redirect to '/'
  end

  quote = Quote.new
  quote.script = params[:script]
  quote.character = params[:character]

  if Play.ids.include?(params[:play_id])
    quote.play_id = params[:play_id]
    quote.save
  end

  redirect to '/my_quotes'
end

get '/quotes/:id/edit' do
  @quote = Quote.find(params[:id])

  @current_user = current_user

  if !@current_user.admin?
    redirect to '/'
  end

  erb :quotes_edit
end


put '/quotes/:id' do
  @current_user = current_user

  if !@current_user.admin?
    redirect to '/'
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

get '/search' do
  erb :search
end

get '/search/:play_id' do


  idOfPlay = Play.id
  @result = Quote.all.where(play_id: idOfPlay)

  erb :search_result
end

get '/search_result' do
  @search_params = params['search']
  play_id = Play.all.where(title: @search_params)

  @relevant_quotes = Quote.all.where(play_id: play_id)

  erb :search_result
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

############################

get '/my_quotes' do
  @quotes = Quote.all
  @current_user = current_user

  erb :my_quotes
end

get '/my_plays' do
  @current_user = current_user
  @plays = Play.all

  erb :my_plays
end

##############################

get '/play_game' do

  @quote = Quote.all.sample
  @play_title = Play.all.where(id: @quote.play_id)
  @randomPlays = (Play.all - Play.where(id: @quote.play_id)).shuffle.take(3)
  @unshuffled_list = @play_title + @randomPlays
  erb :play_game

end

get '/finished_game/:quote_play_id/:play_id' do

  quote_play_id = params[:quote_play_id]
  play_id = params[:play_id]

  if quote_play_id == play_id
    # session[:score] = session[:score] + 1
    redirect to '/answer_correct'
  else
    redirect to '/answer_incorrect'
  end

end

get '/answer_correct' do

  @current_user = User.find_by(id: current_user.id)
  # current_score = current_user.current_score


  @quote = Quote.all.sample
  @play_title = Play.all.where(id: @quote.play_id)
  @randomPlays = (Play.all - Play.where(id: @quote.play_id)).shuffle.take(3)
  @unshuffled_list = @play_title + @randomPlays


  # current_score = current_score + 1
  user = current_user

  user.current_score = user.current_score + 1
  user.save

  # current_user.save
  # current_user.current_score = current_score
  erb :answer_correct
end

get '/answer_incorrect' do

  @current_user = User.find_by(id: current_user.id)

  @quote = Quote.all.sample
  @play_title = Play.all.where(id: @quote.play_id)
  @randomPlays = (Play.all - Play.where(id: @quote.play_id)).shuffle.take(3)
  @unshuffled_list = @play_title + @randomPlays
  # check new score against database

  if @current_user.current_score > @current_user.high_score
    @current_user.high_score = @current_user.current_score
    @current_user.save
  end

  @current_user.current_score = 0
  @current_user.save

  erb :answer_incorrect
end

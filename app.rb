require 'sinatra'
require 'sinatra/activerecord'
require './models/user'

set :database, {adapter: "sqlite3", database: "cnline.sqlite3"}


get '/' do
  erb :index
end


### User START ###

get '/signup' do
  erb :'/signup'
end

post '/signup' do
 puts params
 @user = User.new(username: params["username"],
                 password: params["password"])
 @user.save
 session[:id] = @user.id
 redirect '/users'
end

get '/login' do
  erb :'/login'
end

post '/login' do
  puts params
  @user = User.find_by(username: params["username"],
                      password: params["password"])
  session[:id] = @user.id
end

get '/logout' do
  session.clear
end

get '/users' do
  @user = User.find(session[:id])
  erb :'/users'
end

### User END ###

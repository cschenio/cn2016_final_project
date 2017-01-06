require 'sinatra'
require 'sinatra/activerecord'
require './models/user'

set :database, {adapter: "sqlite3", database: "cnline.sqlite3"}

enable :sessions

get '/' do
  erb :index
end


### User START ###

get '/signup' do
  erb :'/signup/index'
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
  erb :'/login/index'
end

post '/login' do
  puts params
  @user = User.find_by(:username => params["username"],
                      :password => params["password"])

  if @user.nil?
    puts "User not found"
    redirect '/error'
  else
    session[:id] = @user.id
    redirect '/users'
  end
end

get '/logout' do
  session.clear
  puts "logout"
  redirect '/'
end

get '/users' do
  if session[:id]
    @user = User.find(session[:id])
    erb :'/users/index'
  else
    redirect '/error'
  end
end

get '/error' do
  erb :'error'
end

### User END ###

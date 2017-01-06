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
 @is_exists = User.find_by(username: params["username"])
 if @is_exists
   redirect '/error/1'
 else
   @user = User.new(username: params["username"],
                 password: params["password"])
   @user.save
   session[:id] = @user.id
   redirect '/users'
 end
end

get '/login' do
  erb :'/login/index'
end

post '/login' do
  puts params
  @user = User.find_by(username: params["username"],
                      password: params["password"])

  if @user.nil?
    redirect '/error/2'
  else
    session[:id] = @user.id
    redirect '/users'
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/users' do
  if session[:id]
    @user = User.find(session[:id])
    erb :'/users/index'
  else
    redirect '/error/3'
  end
end

get '/error/:id' do
  @msg = ""
  case params[:id]
  when "1"
    @msg = "This username is existed!"
  when "2"
    @msg = "Username or Password wrong!"
  when "3"
    @msg = "User session error..."
  end
  erb :'error'

end

### User END ###

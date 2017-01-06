require 'sinatra'
require 'sinatra/activerecord'
require './models/user'

set :database, {adapter: "sqlite3", database: "cnline.sqlite3"}

get '/' do
  @user = User.new
  erb :index
end

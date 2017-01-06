require 'sinatra'

# Models
require 'sinatra/activerecord'
require './models/user'
require './models/mail'
require './models/mailbox'
require './models/mail_history'

set :database, {adapter: "sqlite3", database: "cnline.sqlite3"}

get '/' do
  @user = User.new
  erb :index
end

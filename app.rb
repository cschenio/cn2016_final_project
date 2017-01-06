require 'sinatra'
require "sinatra/namespace"
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

namespace '/mails' do 
  get do
    @mails = Mail.all
    erb :'mails/index'
  end

  get '/new' do
    erb :'mails/new'
  end

  get '/:id' do
    @mail = Mail.find(params[:id])
    erb :'mails/show'
  end

  post '/new' do
    mail = Mail.new(:user => User.find(1),# session[:id],
                    :mailbox => User.find(1).mailbox,# User.find(params[:receiver]).mailbox,
                    :title => params[:title],
                    :content => params[:content])
    mail.save
    redirect to('/mails')
  end
end

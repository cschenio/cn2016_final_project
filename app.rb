require 'sinatra'
require "sinatra/namespace"
require 'redcarpet'
require 'rouge'
require 'erubis'
# Models
require 'sinatra/activerecord'
require './models/user'
require './models/mail'
require './models/mailbox'
require './models/mail_history'

# Concerns: reusable modules
require './controller_concerns/permission_authable'

include PermissionAuthable

set :database, {adapter: "sqlite3", database: "cnline.sqlite3"}

enable :sessions

get '/' do    
  erb :index
end

namespace '/mails' do 

  before do 
    redirect to('/') unless has_permission?("user")
  end

  get do
    @mails = if has_permission?("super")
               Mail.all
             else
               Mail.related_to(User.find(session[:id]))
             end
    erb :'mails/index'
  end

  get '/new' do
    @number_of_users = User.count
    erb :'mails/new'
  end

  get '/:id' do
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, no_intra_emphasis: true)
    @mail = Mail.find(params[:id])
    redirect to('/mails') unless my_mail?(@mail)
    erb :'mails/show'
  end

  post '/new' do
    mail = Mail.new(:user => User.find(session[:id]),
                    :mailbox => User.find(params[:receiver]).mailbox,
                    :title => params[:title],
                    :content => params[:content])
    mail.save
    redirect to('/mails')
  end
end


namespace '/users' do
  
  before '/signup' do
  	#puts "request.path = #{request.path}" # print current url
  	redirect to('/users') if has_permission?("user")
  end

  before '/login' do
  	#puts "request.path = #{request.path}" # print current url
  	redirect to('/users') if has_permission?("user")
  end

  get do
  	redirect to('/users/login') unless has_permission?("user")
  	@user = User.find(session[:id])
  	@users = (has_permission?("super"))? User.all : nil
  	erb :'users/index'
  end

  get '/signup' do
    erb :'users/signup'
  end
  
  post '/signup' do
    puts params
    user_exists = User.find_by(:username => params["username"])
    if user_exists
      redirect to('/error/user_exists')
    else
      user = User.new(:username => params["username"],
                      :password => params["password"],
                      :super => (params["super"].nil?)? false : true)
      user.save
      session[:id] = user.id
      redirect to('/users')
    end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    puts params
    user = User.find_by(:username => params["username"])
    redirect to('/error/user_not_found') if user.nil?
    redirect to('/error/password_wrong') if params["password"] != user.password
    session[:id] = user.id
    redirect to('/users')
  end

  get '/logout' do
  	puts "logout"
    session.clear
    redirect to('/')
  end

end

namespace '/error' do

	get '/:cond' do
	  @msg = case params[:cond]
	  			 when "user_exists" then "The account already exists."
					 when "user_not_found" then "The account doesn't exist."
					 when "password_wrong" then "Password is wrong!"
					 else ""
					 end
	  erb :'error'
	end

end
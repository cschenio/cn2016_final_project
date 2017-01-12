require 'sinatra'
require "sinatra/namespace"
# Models
require 'sinatra/activerecord'
require './models/user'
require './models/online'
require './models/online_file'
require './models/mail'
require './models/mailbox'
require './models/mail_history'
# Concerns: reusable modules
require './controller_concerns/permission_authable'

include PermissionAuthable

# File transfer
require 'fileutils'

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


namespace '/files' do
	$file_path = '/Users/Chang/github/cn2016_final_project/uploads'

	before do
		redirect to('/') unless has_permission?("user")
	end

	get do
		@user = User.find(session[:id])
		online = Online.find_by(:username => @user.username)
		online.has_file = false # the user has been here

		@user_file = Online_file.where(:to => @user.username)
		puts @user_file.count unless @user_file.nil?
		@online_users = Online.all
		erb :'files/index'
	end

	get '/upload/:user' do
		@receiver = User.find_by(:username => params[:user])
		redirect to('/files'), :notice => "no this user" if @receiver.nil?
		erb :'files/upload'
	end

	post '/upload/:user' do
		@sender = User.find(session[:id])
		puts params['file']
		if params['file'] && params['file'][:filename]
			filename = params['file'][:filename]
			tempfile = params['file'][:tempfile]
			root_path = $file_path + "/#{params[:user]}/#{@sender.username}"
			puts "root_path = #{root_path}"
			puts filename
			#File.copy(tempfile.path, "#{root_path}/#{filename}")
			FileUtils.mkdir_p(root_path) unless File.exist?(root_path)
			File.open("#{root_path}/#{filename}", 'wb') do |f|
      	f.write(tempfile.read)
    	end

    	overwritten = Online_file.find_by(:from => @sender.username,
    		                                :to => params[:user],
    		                                :filename => filename)

			Online_file.create(:from => @sender.username,
				                 :to => params[:user],
				                 :filename => filename)
			receiver = Online.find_by(:username => params[:user])
			receiver.has_file = true
			return "The file was successfully uploaded!"
		end
	end

	get '/download/:sender/:file' do
		# Open the file under current username and download it...
		user = User.find(session[:id])
		path = $file_path + "/#{user.username}/#{params[:sender]}/#{params[:file]}"
		puts path

		redirect to('/error/nofile') if !File.exist?(path)
		send_file path, :filename => params[:file], :disposition => 'attachment'
		puts "after send the file"
		# DEBUG: it will turn to other page after send_file
		File.delete(path)
		onlinefile = Online_file.find_by(:from => params[:sender],
			                                :to => user.username,
			                                :filename => params[:file])
		onlinefile.destroy_all	
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
  	@has_file = Online.find_by(:username => @user.username).has_file
  	@users = (has_permission?("super"))? User.all : nil
  	erb :'users/index'
  end

### DEBUG
  get '/online' do
  	online_users = Online.all
  	puts "online"
  	if online_users
  		online_users.each { |user| puts user.username }
  	else
  		puts "no online user"
  	end
  end
###

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
      online = Online.create(:username => user.username, :has_file => false)
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
    puts
    puts "create online object"
    online = Online.create(:username => params["username"], :has_file => false)
    redirect to('/users')
  end

  get '/logout' do
  	puts "logout"

  	user = User.find(session[:id])
  	session.clear

  	online_user = Online.find_by(:username => user.username)
  	online_user.destroy unless online_user.nil?
  	
  	user_files = Online_file.where(:to => user.username)
  	user_dir = $file_path + "/#{user.username}"
  	puts user_dir
  	if File.exist?(user_dir)
  		puts "delete dir now..."
  		FileUtils.remove_dir(user_dir, true) 
  	end
  	user_files.destroy_all unless user_files.nil?

    redirect to('/')
  end

end

namespace '/error' do

	get '/:cond' do
	  @msg = case params[:cond]
	  			 when "user_exists" then "The account already exists."
					 when "user_not_found" then "The account doesn't exist."
					 when "password_wrong" then "Password is wrong!"
					 when "nofile" then "File download error!"
					 else ""
					 end
	  erb :'error'
	end

end


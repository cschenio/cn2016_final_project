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
require './models/code'

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
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, 
                                       autolink: true, 
                                       tables: true, 
                                       no_intra_emphasis: true)
    @mail = Mail.find(params[:id])

    @content = markdown.render(@mail.content)

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

namespace '/codes' do
  formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')

  get do
    @codes = Code.all
    erb :'codes/index'
  end

  get '/new' do    
    @lang_list = Rouge::Lexers.constants.select {|c| Rouge::Lexers.const_get(c).is_a? Class}.map{|c| c.to_s}
    erb :'codes/new'
  end

  get '/:id' do
    @code = Code.find(params[:id])
    @lang = @code.lang
    lexer = Rouge::Lexers.const_get(@lang.to_sym).send(:new) 
    @content = formatter.format(lexer.lex(@code.content))
    @style = Rouge::Themes::Base16.render(scope: '.highlight')
    erb :'codes/show'
  end

  post '/new' do
    p params[:content]
    code = Code.new(:user => User.find(1),# session[:id],
                    :mailbox => User.find(1).mailbox,# User.find(params[:receiver]).mailbox,
                    :lang => params[:lang],
                    :content => params[:content])
    code.save
    redirect to('/codes')
  end
end

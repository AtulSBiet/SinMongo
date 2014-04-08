require 'sinatra'
require 'mongoid'
require 'json'

configure do
  Mongoid.configure do |config|
    # Development
    # config.sessions = {
      # :default => {
      # :hosts => ["localhost:27017"],
      # :database => "my_db"
    # }

    # Production
     config.sessions = {
       :default => {
       :hosts => ["192.168.2.53:7655"],            # VM IP and VM Port
       :database => "t",         # Database Name   
       :username => 'a584mx32xi92tebi',              # User Name 
       :password => 'am3o8djg2deuhiddfgb6nrsthj3c62es'               # Password
     }
  }
  end
end

class User
  include Mongoid::Document
  
  field :name, type: String
  field :email, type: String
  field :desc, type: String
end

# heler methods should come here
helpers do
  def link_to(url,text=url,opts={})
    attributes = ""
	opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
	"<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end

  def delete_user_button(user_id)
    erb :_delete_user_button, locals: { user_id: user_id}
  end
end

# Get all of our routes
# root URL for user
get '/' do
  @users = User.all
  erb :'users/index'
end

# Get the New User form
get '/new' do
  @user = User.new
  erb :'users/new'
end

# Create user date and render to user details page(index)
post '/user' do
  User.create(:name => params[:name], :email => params[:email], :desc => params[:desc])
  @users = User.all
  erb :'users/index'
end

# Deletes the user with this ID and redirects to homepage.
delete "/user/:id" do
  @user = User.find(params[:id]).destroy
  redirect "/"
end

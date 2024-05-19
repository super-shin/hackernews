require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "sinatra/flash"
require "bcrypt"

require_relative "../config/application"

set :root, File.expand_path("..", __dir__)
set :views, proc { File.join(root, "app/views") }
set :bind, '0.0.0.0'

enable :sessions

after do
  ActiveRecord::Base.connection.close
end

get "/" do
  @posts = Post.all
  erb :posts
end

get "/register" do
  erb :register
end

post "/register" do
  user = User.new(email: params[:email], username: params[:username], password_hash: params[:password])
  # user.password = BCrypt::Password.create(params[:password])

  if user.save
    session[:user_id] = user.id
    redirect "/"
  else
    flash[:error] = user.errors.full_messages.join(", ")
    redirect "/register"
  end
end

get "/login" do
  erb :login
end

post "/login" do
  user = User.find_by(email: params[:email])

  if user && BCrypt::Password.new(user.password_hash) == params[:password]
    session[:user_id] = user.id
    redirect "/"
  else
    flash[:error] = "Invalid email or password"
    redirect "/login"
  end
end

get "/logout" do
  session.clear
  redirect "/"
end

get "/posts/new" do
  redirect "/login" unless logged_in?
  erb :new_post
end

post "/posts" do
  redirect "/login" unless logged_in?
  post = current_user.posts.new(title: params[:title], url: params[:url])

  if post.save
    redirect "/"
  else
    flash[:error] = post.errors.full_messages.join(", ")
    redirect "/posts/new"
  end
end

helpers do
  def logged_in?
    !!session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end
end

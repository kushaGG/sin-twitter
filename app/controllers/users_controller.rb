class UsersController < ApplicationController
  get '/signup' do
    if !logged_in?
      erb :'/users/create_user'
    else
      redirect '/users/show'
    end
  end

  post '/signup' do
    @user = User.create(email: params[:email], user_name: params[:user_name], password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect "users/#{@user.id}"
    else
      @signuperror = @user.errors.full_messages.first
      redirect to '/signup'
    end
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(user_name: params[:user_name])  # Check if the user exists
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "users/#{@user.id}"
    else
      redirect to '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/'
    else
      redirect to '/'
    end
  end

  get '/users/:id' do
    id = User.find_by(id: params[:id])

    @currenttweets = Tweet.where(user_id: id).order("created_at DESC")
    @user = User.find(id)
    erb :"users/profile"
  end

  get '/users/:id/edit' do
    @user = User.find(params[:id])
    erb :"users/edit"
  end

  patch '/users/:id' do
    @user = User.find(params[:id])
    @user.user_name = params[:user_name]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.save
    redirect "/users/#{@user.id}"
  end

  get '/users/:id/checkfollowers' do
    id = params[:id]
    @user = User.find(id)
    erb :"users/checkfollowers"
  end

  get '/users/:id/checkfollowing' do
    id = params[:id]
    @user = User.find(id)
    erb :"users/checkfollowing"
  end

  get '/search' do
    if params[:search]
      @users = User.search(params[:search])
    end
    erb :"users/results"
  end
end

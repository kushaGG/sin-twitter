class UsersController < ApplicationController
  get '/sign_up' do
    if !logged_in?
      erb :'/users/sign_up'
    else
      redirect '/users/show'
    end
  end

  post '/sign_up' do
    @user = User.create(email: params[:email], user_name: params[:user_name], password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect "users/#{@user.id}"
    else
      @sign_uperror = @user.errors.full_messages.first
      redirect to '/sign_up'
    end
  end

  get '/sign_in' do
    erb :'/users/sign_in'
  end

  post '/sign_in' do
    @user = User.find_by(user_name: params[:user_name])  # Check if the user exists
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "users/#{@user.id}"
    else
      redirect to '/sign_in'
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
    @messages = current_user.messages
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

  get '/users/send_message/:reciever_id' do
    @user = User.find(params[:reciever_id])
    erb :"users/send_message"
  end

  post '/users/send_message/:reciever_id' do
    @user = User.find(params[:reciever_id])
    a = Message.new(sender_id:current_user.id,user_id:params[:reciever_id],message_body:params[:message_body])
    @user.messages.push(a)
    redirect '/'
  end

  get '/users/messages/:id' do
    @user = User.find(params[:id])
    @messages = current_user.messages
    erb :"users/messages"
  end
end

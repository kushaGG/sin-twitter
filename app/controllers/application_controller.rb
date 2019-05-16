require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "my_application_secret"
  end

  get "/" do
    if logged_in?
      @following_id = current_user.followed.map(&:id).push(current_user.id)
    	@maintweets = Tweet.where(user_id: @following_id).order("created_at DESC")
      erb :index
    else
      erb :"users/sign_in"
    end
  end

  helpers do
    def current_user
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      end
    end

    def logged_in?
      !current_user.nil?
    end
  end

end

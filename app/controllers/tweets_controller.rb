class TweetsController < ApplicationController
  get '/tweet' do
    erb :'tweets/tweet'
  end

  get '/users/:id' do
    if logged_in?
      @tweets = current_user.tweets
      erb :'user/show'
    else
      redirect to '/login'
    end
  end

  def tweet_params
    params.require(:tweet).permit(:body, :user_id)
  end

  post '/tweet' do
    tweet = Tweet.new(params[:tweet])
    tweet.user_id = current_user.id
    if tweet.save
      redirect to "/"
    else
  	   @error = @tweet.errors.full_messages.first #the error is from the validation whenever you try to save something in
    end
  end

  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    erb :"tweets/tweet"
  end


  post '/tweets/:id/delete' do
    @tweet = Tweet.delete(params[:id])
    redirect "/"
  end

  get '/tweets/:id/edit' do  #load edit form
    @tweet = Tweet.find(params[:id])
    erb :"tweets/edit"
  end

  patch '/tweets/:id' do #edit action
    @tweet = Tweet.find(params[:id])
    @tweet.body = params[:boyd]
    @tweet.save
    redirect "/tweets/#{@tweet.id}"
  end
end

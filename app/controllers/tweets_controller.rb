class TweetsController < ApplicationController
  get '/tweet' do
    erb :'tweets/tweet'
  end

  get '/users/:id' do
    if logged_in?
      @tweets = current_user.tweets
      erb :'user/show'
    else
      redirect to '/sign_in'
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
  	   @error = @tweet.errors.full_messages.first
    end
  end

  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    erb :"tweets/tweet"
  end


  delete '/tweets/:id' do
    @tweet = Tweet.delete(params[:id])
    redirect "/"
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])
    erb :"tweets/edit"
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    @tweet.body = params[:boyd]
    @tweet.save
    redirect "/tweets/#{@tweet.id}"
  end
end

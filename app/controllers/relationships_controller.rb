class RelationshipsController < ApplicationController
  post "/users/:id/follow" do
    @user = User.find(params[:id])
    current_user.follow!(@user) if @user
    redirect "users/#{@user.id}"
  end

  post '/users/:id/unfollow' do
    @user = User.find(params[:id])
    current_user.relationships.find_by(followed_id: params[:id]).destroy
    redirect "users/#{@user.id}"
  end
end

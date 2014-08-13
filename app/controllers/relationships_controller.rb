class RelationshipsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @followed_user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@followed_user)
    respond_to do |format|
      format.html { redirect_to @followed_user }
      format.js
    end
  end

  private

end

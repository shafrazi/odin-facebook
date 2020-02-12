class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @friendship = current_user.friendships.build(friend_id: params[:user_id])

    if @friendship.save
      flash[:success] = "Added #{@friendship.friend.name} as friend successfully."
      redirect_to(request.referrer)
    else
      flash[:danger] = "Error adding friend! Please try again."
      redirect_to(request.referrer)
    end
  end

  def index
    @friendships = current_user.friendships
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:danger] = "Unfriended #{@friendship.friend.name} successfully."
    redirect_to request.referrer
  end
end

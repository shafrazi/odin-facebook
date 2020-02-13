class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sent_friend_requests = current_user.sent_friend_requests
    @received_friend_requests = current_user.received_friend_requests
  end

  def create
    @friend_request = current_user.sent_friend_requests.build(requestee_id: params[:requestee_id])
    if @friend_request.save
      flash[:success] = "Friend request sent to #{@friend_request.requestee.name}."
      redirect_to request.referrer
    else
      flash[:danger] = "Error in request. Please try again!"
      redirect_to request.referrer
    end
  end

  def accept_friend_request
    @friend_request = FriendRequest.find(params[:id])
    @friendship = current_user.friendships.build(friend_id: @friend_request.requestor.id)
    @friend_request.destroy

    if @friendship.save
      flash[:success] = "Added #{@friendship.friend.name} as friend successfully."
      redirect_to(request.referrer)
    else
      flash[:danger] = "Error adding friend! Please try again."
      redirect_to(request.referrer)
    end
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy
    flash[:danger] = "Friend request deleted!"
    redirect_to request.referrer
  end
end

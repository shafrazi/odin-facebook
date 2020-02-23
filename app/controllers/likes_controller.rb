class LikesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    unless current_user.liked?(post)
      @like = post.likes.build(user_id: current_user.id)
      if @like.save
        redirect_to request.referrer
      end
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    redirect_to request.referrer
  end
end

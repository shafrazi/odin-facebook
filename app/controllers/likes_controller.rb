class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    unless current_user.liked?(@post)
      @like = @post.likes.build(user_id: current_user.id)
      @like.save
      respond_to do |format|
        format.html { redirect_to request.referrer }
        format.js
      end
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    @like.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end
  end
end

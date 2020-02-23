class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.build(content: params[:content], user_id: current_user.id)
    if @comment.save
      flash[:success] = "Comment posted successfully."
      redirect_to request.referrer
    end
  end
end

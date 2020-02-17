class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def user_posts
    @posts = current_user.posts
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = "Post created!"
      redirect_to(root_path)
    else
      flash[:danger] = "Invalid post! Please try again."
      render("static_pages/home")
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to(request.referrer || root_path)
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end

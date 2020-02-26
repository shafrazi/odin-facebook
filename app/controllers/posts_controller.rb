class PostsController < ApplicationController
  require "mini_magick"

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
    if params[:post][:photo]
      photo = params[:post][:photo]
      mini_image = MiniMagick::Image.new(photo.tempfile.path)
      mini_image.resize "300x300"
    end

    if @post.save
      flash[:success] = "Post created!"
      redirect_to(root_path)
    else
      flash[:danger] = "Invalid post! Please try again."
      redirect_to root_path
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to(request.referrer || root_path)
  end

  private

  def post_params
    params.require(:post).permit(:content, :photo)
  end
end

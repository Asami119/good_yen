class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def post_params
    params.require(:post).permit(:date_of_post, :select_yen, :price, :memo1, :memo2).merge(user_id: current_user.id)
  end
end

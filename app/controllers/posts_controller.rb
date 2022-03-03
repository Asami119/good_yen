class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
  end

  def new
    @post = Post.new
    @posts = Post.where(user_id: current_user.id).order(date_of_post: 'DESC')
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to new_post_path
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:date_of_post, :select_yen, :price, :memo1, :memo2).merge(user_id: current_user.id)
  end
end

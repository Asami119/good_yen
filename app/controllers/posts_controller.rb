class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :destroy]

  def index
  end

  def new
    @post = Post.new
    @posts = Post.search_month(current_user.id)
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to new_post_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to new_post_path
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to new_post_path
  end

  def search
    set_memo_search
    @q = current_user.posts.ransack(params[:q])
    @posts = @q.result.order(date_of_post: 'DESC')
    @price_for_graph, @price_true_percent = Post.calc_for_graph(@posts)
  end

  private

  def post_params
    params.require(:post).permit(:date_of_post, :select_yen, :price, :memo1, :memo2).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def move_to_index
    redirect_to root_path unless current_user.id == @post.user_id
  end

  def set_memo_search
    if params[:q]&.dig(:memo1)
      squished_keywords = params[:q][:memo1].squish
      params[:q][:memo1_cont_any] = squished_keywords.split('')
    end
    return true if params[:q]&.dig(:memo2).blank?

    squished_keywords = params[:q][:memo2].squish
    params[:q][:memo2_cont_any] = squished_keywords.split('')
  end
end

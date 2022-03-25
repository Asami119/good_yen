class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :destroy]

  def index
  end

  def new
    @post = Post.new
    posts, @sum_price_month, @count_post = Post.search_month(current_user.id)
    @pagy, @posts = pagy(posts, items: 5)
  end

  def create
    @post = Post.new(post_params)
    posts, @sum_price_month, @count_post = Post.search_month(current_user.id)
    @pagy, @posts = pagy(posts, items: 5)

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
    posts = @q.result.order(date_of_post: :DESC, created_at: :DESC)
    @count_post = posts.count
    @pagy, @posts = pagy(posts, items: 10)
    @price_for_graph, @price_true_percent = Post.calc_donut(@posts)
    @price_month, @price_year = Post.calc_column(@posts)

    @price_month_average = Post.calc_month_average(@price_month, @price_year) unless @price_year.zero?

    if params[:show_donut]
      render :donut
    elsif params[:show_column]
      render :column
    elsif params[:show_bar]
      render :bar
    elsif params[:export_csv]
      send_posts_csv(posts)
    else
      render :search
    end
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
      params[:q][:memo1_cont_any] = squished_keywords.split(' ')
    end
    return true if params[:q]&.dig(:memo2).blank?

    squished_keywords = params[:q][:memo2].squish
    params[:q][:memo2_cont_any] = squished_keywords.split(' ')
  end

  def send_posts_csv(posts)
    bom = "\xEF\xBB\xBF"
    csv_data = CSV.generate(bom, force_quotes: true) do |csv|
      header = %w[日付 金額 Good_yen? メモ1 メモ2]
      csv << header

      posts.each do |post|
        values = [post.date_of_post, post.price, post.select_yen, post.memo1, post.memo2]
        csv << values
      end
    end
    time_now = Time.now.strftime('%Y%m%d-%H%M%S')
    send_data(csv_data, filename: "記録一覧#{time_now}.csv", type: :csv)
  end
end

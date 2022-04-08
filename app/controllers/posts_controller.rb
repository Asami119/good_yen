class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :destroy]

  def index
  end

  def new
    @post = Post.new
    set_list
  end

  def create
    @post = Post.new(post_params)
    set_list
    if @post.save
      flash[:notice] = '1件の記録を「保存」しました。'
      redirect_to new_post_path
    else
      render :new
    end
  end

  def edit
    session[:previous_url] = request.referer || new_post_path
  end

  def update
    if @post.update(post_params)
      flash[:notice] = '1件の記録を「変更」しました。'
      redirect_to session[:previous_url]
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = '1件の記録を「削除」しました。'
    redirect_back(fallback_location: new_post_path)
  end

  def search
    set_memo_search
    @q = current_user.posts.ransack(params[:q])
    posts = @q.result.order(date_of_post: :DESC, created_at: :DESC)
    @post_count, @price_sum = Post.calc_post(posts)
    @pagy, @posts = pagy(posts, items: 10)
    @querys = Post.make_query(params[:q])
    @period = Post.calc_period(current_user.id)

    if params[:show_donut]
      @price_sums, @price_true_percent = Post.calc_donut(posts) if posts.present?
      render :donut
    elsif params[:show_column] || params[:show_bar]
      @monthly_price_sums, @monthly_price_average = Post.calc_column_and_bar(params, posts, @price_sum) if posts.present?
      if params[:show_column]
        render :column
      else
        render :bar
      end
    elsif params[:export_csv]
      send_posts_csv(posts)
    else
      render :search
    end
  end

  def select
    post = current_user.posts.where(select_yen: true)
    if post.present?
      @post_count = post.count
      @post = post.sample
    end
  end

  private

  def post_params
    params.require(:post).permit(:date_of_post, :select_yen, :price, :memo1, :memo2).merge(user_id: current_user.id)
  end

  def set_list
    posts, @monthly_price_sum, @monthly_post_count = Post.search_month(current_user.id)
    @pagy, @posts = pagy(posts, items: 10)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def move_to_index
    redirect_to root_path unless current_user.id == @post.user_id
  end

  def set_memo_search
    if params[:q]&.dig(:memo1).present?
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
    time_now = Time.now.strftime('%Y%m%d')
    send_data(csv_data, filename: "記録一覧#{time_now}.csv", type: :csv)
  end
end

class Post < ApplicationRecord
  belongs_to :user

  validates :date_of_post, :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: 'は1以上の半角数字のみ入力できます' }
  validates :select_yen, inclusion: [true, false]

  def self.search_month(current_user_id)
    @posts = Post.where(user_id: current_user_id).where(
      date_of_post: Time.now.beginning_of_month..Time.now.end_of_month
    ).order(date_of_post: :DESC, created_at: :DESC)
    @sum_price_month = @posts.sum(:price)
    @count_post = @posts.count
    [@posts, @sum_price_month, @count_post]
  end

  def self.calc_post(posts)
    post_count = posts.count
    price_sum = posts.sum(:price)
    [post_count, price_sum]
  end

  def self.calc_donut(posts)
    price_true = posts.where(select_yen: true).sum(:price)
    price_false = posts.where(select_yen: false).sum(:price)
    price_total = (price_true + price_false).to_f
    price_true_percent = (price_true / price_total * 100).floor(1)
    [{ 'Good yen!': price_true, 'あと一歩': price_false }, price_true_percent]
  end

  def self.set_month(posts, year, first_month, last_month, price_true_sums, price_false_sums)
    first_month.upto(last_month) do |i|
      first_day = Time.new(year, i, 1)
      month_post = posts.where(date_of_post: first_day..first_day.end_of_month)
      price_true = month_post.where(select_yen: true).sum(:price)
      price_false = month_post.where(select_yen: false).sum(:price)

      price_true_sums.push(["#{year}-#{i}月", price_true])
      price_false_sums.push(["#{year}-#{i}月", price_false])
    end
    [price_true_sums, price_false_sums]
  end

  def self.calc_monthly_average(monthly_price_sums, price_sum)
    month_count = monthly_price_sums.dig(0, :data).count
    monthly_price_average = price_sum / month_count
  end

  def self.calc_column_and_bar(params, posts, price_sum)
    if params.dig(:q, :date_of_post_gteq).present?
      gteq = params.dig(:q, :date_of_post_gteq).to_date
    else
      gteq = posts.last[:date_of_post]
    end

    if params.dig(:q, :date_of_post_lteq).present?
      lteq = params.dig(:q, :date_of_post_lteq).to_date
    else
      lteq = posts.first[:date_of_post]
    end

    old_year = gteq.year
    old_month = gteq.month
    new_year = lteq.year
    new_month = lteq.month

    price_true_sums = []
    price_false_sums = []

    if old_year == new_year
      set_month(posts, old_year, old_month, new_month, price_true_sums, price_false_sums)
    else
      january = 1
      december = 12

      set_month(posts, old_year, old_month, december, price_true_sums, price_false_sums)
      old_year += 1
      while old_year != new_year
        set_month(posts, old_year, january, december, price_true_sums, price_false_sums)
        old_year += 1
      end
      set_month(posts, old_year, january, new_month, price_true_sums, price_false_sums)
    end

    monthly_price_sums = [{ name: 'Good yen!', data: price_true_sums }, { name: 'あと一歩', data: price_false_sums }]
    monthly_price_average = calc_monthly_average(monthly_price_sums, price_sum)
    [monthly_price_sums, monthly_price_average]
  end

  private_class_method :set_month, :calc_monthly_average
end

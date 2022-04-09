class Post < ApplicationRecord
  belongs_to :user

  validates :date_of_post, :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: 'は1以上の半角数字のみ入力できます' }
  validates :select_yen, inclusion: [true, false]

  def self.search_month(current_user_id)
    posts = Post.where(user_id: current_user_id).where(
      date_of_post: Time.now.all_month
    ).order(date_of_post: :DESC, created_at: :DESC)
    monthly_price_sum = posts.sum(:price)
    monthly_post_count = posts.count
    [posts, monthly_price_sum, monthly_post_count]
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

  def self.set_month(posts, year, first_month, last_month, array)
    first_month.upto(last_month) do |i|
      first_day = Time.new(year, i, 1)
      month_post = posts.select(:select_yen, :price).where(date_of_post: first_day.all_month)
      price_true = month_post.where(select_yen: true).sum(:price)
      price_false = month_post.where(select_yen: false).sum(:price)

      array[0].push(["#{year}-#{i}月", price_true])
      array[1].push(["#{year}-#{i}月", price_false])
    end
    array
  end

  def self.calc_monthly_average(monthly_price_sums, price_sum)
    month_count = monthly_price_sums.dig(0, :data).count
    (price_sum / month_count)
  end

  def self.calc_column_and_bar(params, posts, price_sum)
    gteq = if params.dig(:q, :date_of_post_gteq).present?
             params.dig(:q, :date_of_post_gteq).to_date
           else
             posts.last[:date_of_post]
           end
    lteq = if params.dig(:q, :date_of_post_lteq).present?
             params.dig(:q, :date_of_post_lteq).to_date
           else
             posts.first[:date_of_post]
           end

    old_year = gteq.year
    old_month = gteq.month
    new_year = lteq.year
    new_month = lteq.month

    price_true_sums = []
    price_false_sums = []
    array = [price_true_sums, price_false_sums]

    if old_year == new_year
      set_month(posts, old_year, old_month, new_month, array)
    else
      january = 1
      december = 12
      set_month(posts, old_year, old_month, december, array)
      old_year += 1
      while old_year != new_year
        set_month(posts, old_year, january, december, array)
        old_year += 1
      end
      set_month(posts, old_year, january, new_month, array)
    end

    monthly_price_sums = [{ name: 'Good yen!', data: price_true_sums }, { name: 'あと一歩', data: price_false_sums }]
    [monthly_price_sums, calc_monthly_average(monthly_price_sums, price_sum)]
  end

  def self.calc_period(current_user_id)
    period = {}
    posts = Post.select(:date_of_post).where(user_id: current_user_id).order(date_of_post: :DESC)
    if posts.present?
      first_post = posts.last[:date_of_post]
      last_post = posts.first[:date_of_post]
      day = (last_post - first_post + 1).to_i
      period = { first_post: first_post, last_post: last_post, day: day }
    end
    period
  end

  def self.make_query(q)
    querys = []
    if q.blank?
      querys << '・すべて表示'
    else
      if q[:date_of_post_gteq].present? || q[:date_of_post_lteq].present?
        querys << "・#{q[:date_of_post_gteq]} 〜 #{q[:date_of_post_lteq]}"
      end

      if q[:price_gteq].present? && q[:price_lteq].present?
        querys << "・#{q[:price_gteq].to_i.to_s(:delimited)}円 〜 #{q[:price_lteq].to_i.to_s(:delimited)}円"
      else
        querys << "・#{q[:price_gteq].to_i.to_s(:delimited)}円 〜" if q[:price_gteq].present?
        querys << "・〜 #{q[:price_lteq].to_i.to_s(:delimited)}円" if q[:price_lteq].present?
      end

      if q[:select_yen_eq].present?
        querys << '・「Good yen!」のみ' if q[:select_yen_eq] == 'true'
        querys << '・「あと一歩」のみ' if q[:select_yen_eq] == 'false'
      end

      querys << "・メモ①：#{q[:memo1]}" if q[:memo1].present?
      querys << "・メモ②：#{q[:memo2]}" if q[:memo2].present?
      querys << '・なし（すべて表示）' if querys.blank?
    end
    querys
  end

  private_class_method :set_month, :calc_monthly_average
end
